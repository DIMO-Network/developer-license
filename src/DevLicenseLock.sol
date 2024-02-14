// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {DevLicenseCore} from "./DevLicenseCore.sol";

/** 
 * https://dimo.zone/news/on-dimo-tokenomics
 */
contract DevLicenseLock is DevLicenseCore {

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    uint256 public _minimumStake;

    /*//////////////////////////////////////////////////////////////
                              Mappings
    //////////////////////////////////////////////////////////////*/
    mapping(uint256 => uint256) public _licenseLockUp;
    mapping(uint256 => bool) public _licenseLockUpFrozen;

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    event UpdateMinimumStake(uint256 amount);
    event AssetFreezeUpdate(uint256 tokenId, uint256 amount, bool frozen);
    event AssetForfeit(uint256 tokenId, uint256 amount);
    event Deposit(uint256 indexed tokenId, address indexed user, uint256 amount);
    event Withdraw(uint256 indexed tokenId, address indexed user, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_PARAM = "DevLicenseDimo: invalid param";

    constructor(
        address laf_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_
    ) DevLicenseCore(laf_, provider_, dimoTokenAddress_, dimoCreditAddress_, licenseCostInUsd_) {

        _minimumStake = 1 ether;
    }

    /*//////////////////////////////////////////////////////////////
                         Operative Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * TODO: msg.sender or from param
     * 
     */
    function lock(uint256 tokenId, uint256 amount) public {
        require(amount >= _minimumStake, INVALID_PARAM);
        require(msg.sender == ownerOf(tokenId), INVALID_MSG_SENDER);

        _dimoToken.transferFrom(msg.sender, address(this), amount);

        _licenseLockUp[tokenId] += amount;

        emit Deposit(tokenId, msg.sender, amount);
    }

    function withdraw(uint256 tokenId, uint256 amount) public {
        require(amount > 0, INVALID_PARAM);
        require(!_licenseLockUpFrozen[tokenId], "DevLicenseDimo: funds inaccessible");

        bool validAmount = _licenseLockUp[tokenId] >= amount;
        bool validMin = _licenseLockUp[tokenId] >= _minimumStake;
        require(validAmount && validMin, INVALID_PARAM);

        _licenseLockUp[tokenId] -= amount;

        emit Withdraw(tokenId, msg.sender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            View Functions
    //////////////////////////////////////////////////////////////*/

    function balanceOf(uint256 tokenId) public view returns (uint256 balance) {
        balance = _licenseLockUp[tokenId];
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * TODO: prolly should be a role for this instead of 'onlyOwner'
     */
    function setMinimumLockAmount(uint256 minimumLockAmount_) public onlyOwner {
        _minimumStake = minimumLockAmount_;
        emit UpdateMinimumStake(minimumLockAmount_);
    }

    ///@notice these functions require careful accounting...

    /**
     * TODO: do we want this generalized transfer function, or 
     * do we want to be more restrictive with what we can do...
     */
    // function reallocate(uint256 tokenId, uint256 amount, address to) public onlyOwner {
    //     require(_licenseLockUpTotal[tokenId] <= amount, INVALID_PARAM);

    //     //_licenseLockUpDeposit[tokenId][msg.sender] -= amount;
    //     _licenseLockUpTotal[tokenId] -= amount;

    //     _dimoToken.transferFrom(address(this), to, amount);
    //     emit AdminSanction(tokenId, amount);
    // }

    /**
     * you need to fix this accounting...
     * 
     * we could limit the number of valid signers, to liek 100 or something,,,
     */
    function burn(uint256 tokenId, uint256 amount) public onlyOwner {
        require(_licenseLockUp[tokenId] >= amount, INVALID_PARAM);

        _licenseLockUp[tokenId] -= amount;

        _dimoToken.burn(address(this), amount);

        emit AssetForfeit(tokenId, amount);
    }

    /**
     * role instead of onlyOwner
     */
    function freeze(uint256 tokenId, bool frozen) public onlyOwner {
        _licenseLockUpFrozen[tokenId] = frozen;
        emit AssetFreezeUpdate(tokenId, _licenseLockUp[tokenId], frozen);
    }

}
