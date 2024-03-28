// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {DevLicenseCore} from "./DevLicenseCore.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/** 
 * @title DevLicenseStake
 * @dev Extension of DevLicenseCore to add staking functionality for DIMO tokens.
 * Implements locking of tokens against licenses and facilitates staking rewards and penalties.
 * Utilizes ReentrancyGuard from OpenZeppelin to prevent reentrancy attacks.
 * For more information on DIMO tokenomics: https://dimo.zone/news/on-dimo-tokenomics
 */
contract DevLicenseStake is DevLicenseCore, ReentrancyGuard {

    /*//////////////////////////////////////////////////////////////
                              Member Variable
    //////////////////////////////////////////////////////////////*/
    
    /// @notice Total amount of DIMO tokens staked in the contract.
    uint256 public _stakeTotal;

    /*//////////////////////////////////////////////////////////////
                              Mappings
    //////////////////////////////////////////////////////////////*/

    /// @notice Maps a tokenId to its frozen status, where true indicates it is frozen.
    mapping(uint256 => bool) public _frozen;
    /// @notice Maps a tokenId to the amount of DIMO tokens staked against it.
    mapping(uint256 => uint256) public _stakeLicense;

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a license's assets are frozen or unfrozen.
    event AssetFreezeUpdate(uint256 indexed tokenId, uint256 amount, bool frozen);
    /// @notice Emitted when a license's staked assets are forfeited.
    event AssetForfeit(uint256 indexed tokenId, uint256 amount);
    /// @notice Emitted upon deposit of stake for a license.
    event StakeDeposit(uint256 indexed tokenId, address indexed user, uint256 amount);
    /// @notice Emitted upon withdrawal of stake from a license.
    event StakeWithdraw(uint256 indexed tokenId, address indexed user, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/

    string INVALID_PARAM = "DevLicenseDimo: invalid param";

    /**
     * @dev Initializes the contract by setting a `receiver_`, `licenseAccountFactory_`, `provider_`, `dimoTokenAddress_`, and `dimoCreditAddress_`, and the `licenseCostInUsd_`.
     */
    constructor(
        address receiver_,
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_
    ) DevLicenseCore(receiver_, licenseAccountFactory_, provider_, dimoTokenAddress_, dimoCreditAddress_, licenseCostInUsd_) ReentrancyGuard() {}

    /*//////////////////////////////////////////////////////////////
                         Operative Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Locks `amount` of DIMO tokens as stake against the license with `tokenId`.
     * @dev Transfers DIMO tokens from the caller to the contract.
     * @param tokenId The ID of the license against which tokens are staked.
     * @param amount The amount of DIMO tokens to stake.
     */
    function lock(uint256 tokenId, uint256 amount) external {
        require(msg.sender == ownerOf(tokenId), INVALID_PARAM);

        _dimoToken.transferFrom(msg.sender, address(this), amount);

        _stakeLicense[tokenId] += amount;
        _stakeTotal += amount;

        emit StakeDeposit(tokenId, msg.sender, amount);
    }

    /**
     * @notice Withdraws `amount` of DIMO tokens staked against the license with `tokenId`.
     * @dev Checks for non-reentrancy, valid amounts, ownership, and if the funds are not frozen.
     * @param tokenId The ID of the license from which tokens are withdrawn.
     * @param amount The amount of DIMO tokens to withdraw.
     */
    function withdraw(uint256 tokenId, uint256 amount) public nonReentrant {
        require(amount > 0, INVALID_PARAM);
        require(msg.sender == ownerOf(tokenId), INVALID_PARAM);
        require(!_frozen[tokenId], "DevLicenseDimo: funds inaccessible");
        require(_stakeLicense[tokenId] >= amount, INVALID_PARAM);

        _transferOut(tokenId, amount);
        _dimoToken.transferFrom(address(this), msg.sender, amount);

        emit StakeWithdraw(tokenId, msg.sender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            View Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the total amount of DIMO tokens staked in the contract.
     * @return totalStaked_ The total staked tokens.
     */
    function totalStaked() public view returns (uint256 totalStaked_) {
        totalStaked_ = _stakeTotal;
    }

    /**
     * @notice Returns the amount of DIMO tokens staked against a specific license.
     * @param tokenId The ID of the license.
     * @return licenseStaked_ The amount of tokens staked against the license.
     */
    function licenseStaked(uint256 tokenId) public view returns (uint256 licenseStaked_) {
        licenseStaked_ = _stakeLicense[tokenId];
    }

    /*//////////////////////////////////////////////////////////////
                     Private Helper Function
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Decreases the stake amounts both from the specific license and the total stake.
     * @param tokenId The ID of the license from which tokens are withdrawn.
     * @param amount The amount of DIMO tokens to withdraw.
     */
    function _transferOut(uint256 tokenId, uint256 amount) private {
        _stakeLicense[tokenId] -= amount;
        _stakeTotal -= amount;
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Freezes or unfreezes the assets staked against a license in case of a violation.
     * @param tokenId The ID of the license whose assets are to be frozen or unfrozen.
     * @param frozen The new frozen status of the license's assets.
     */
    function adminFreeze(uint256 tokenId, bool frozen) external onlyRole(LICENSE_ADMIN_ROLE) {
        _frozen[tokenId] = frozen;
        emit AssetFreezeUpdate(tokenId, _stakeLicense[tokenId], frozen);
    }

    /**
     * @notice Forfeits a specified amount of staked assets from a license in case of a violation.
     * @param tokenId The ID of the license whose assets are to be forfeited.
     * @param amount The amount of staked assets to forfeit.
     */
    function adminBurnLockedFunds(uint256 tokenId, uint256 amount) external onlyRole(LICENSE_ADMIN_ROLE) {
        require(_stakeLicense[tokenId] >= amount, INVALID_PARAM);

        _transferOut(tokenId, amount);

        _dimoToken.burn(address(this), amount);
        emit AssetForfeit(tokenId, amount);
    }

    /**
     * @notice Transfers a specified amount of staked assets from a license to another address, in case of administrative reallocation.
     * @param tokenId The ID of the license from which assets are reallocated.
     * @param amount The amount of assets to reallocate.
     * @param to The address to which the assets are reallocated.
     */
    function adminReallocate(uint256 tokenId, uint256 amount, address to) external onlyRole(LICENSE_ADMIN_ROLE) {
        require(_stakeLicense[tokenId] <= amount, INVALID_PARAM);

        _transferOut(tokenId, amount);

        _dimoToken.transfer(to, amount);
        emit AssetForfeit(tokenId, amount);
    }

    /**
     * @notice Allows the contract admin to withdraw DIMO tokens sent to the contract by mistake, excluding staked funds.
     * @dev Calculates the withdrawable amount as the difference between the contract's DIMO token balance and the total staked amount.
     * @param to The address to which the withdrawable DIMO tokens are sent.
     */
    function adminWithdraw(address to) external onlyRole(LICENSE_ADMIN_ROLE) {
        uint256 balaceOf = _dimoToken.balanceOf(address(this));
        uint256 amount = balaceOf - _stakeTotal;
        _dimoToken.transfer(to, amount);
    }

}
