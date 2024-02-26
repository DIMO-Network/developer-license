// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {DevLicenseCore} from "./DevLicenseCore.sol";

import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/** 
 * https://dimo.zone/news/on-dimo-tokenomics
 */
contract DevLicenseLock is DevLicenseCore, ReentrancyGuard {

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
    event AssetFreezeUpdate(uint256 indexed tokenId, uint256 amount, bool frozen);
    event AssetForfeit(uint256 indexed tokenId, uint256 amount);
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
    ) DevLicenseCore(laf_, provider_, dimoTokenAddress_, dimoCreditAddress_, licenseCostInUsd_) ReentrancyGuard() {

        _minimumStake = 1 ether;
    }

    /*//////////////////////////////////////////////////////////////
                         Operative Functions
    //////////////////////////////////////////////////////////////*/

    /**
     */
    function lock(uint256 tokenId, uint256 amount) external {
        lock(tokenId, amount, msg.sender);
    }

    /**
     * TODO: maybe remove this - increases attack surface
     * 
     * @dev any arbitrary account can invoke the lock operation
     * on behalf of an owner that has tokens and has made the 
     * requisite approvals
     */
    function lock(uint256 tokenId, uint256 amount, address owner) public {
        require(amount >= _minimumStake, INVALID_PARAM);
        require(owner == ownerOf(tokenId), INVALID_PARAM);

        _dimoToken.transferFrom(owner, address(this), amount);

        _licenseLockUp[tokenId] += amount;

        emit Deposit(tokenId, owner, amount);
    }

    /**
     */
    function withdraw(uint256 tokenId, uint256 amount) public nonReentrant {
        require(amount > 0, INVALID_PARAM);
        require(msg.sender == ownerOf(tokenId), INVALID_PARAM);
        require(!_licenseLockUpFrozen[tokenId], "DevLicenseDimo: funds inaccessible");

        bool validAmount = _licenseLockUp[tokenId] >= amount;
        bool validMin = _licenseLockUp[tokenId] >= _minimumStake;
        require(validAmount && validMin, INVALID_PARAM);

        _licenseLockUp[tokenId] -= amount;
        _dimoToken.transferFrom(address(this), msg.sender, amount);

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
     */
    function setMinimumLockAmount(uint256 minimumLockAmount_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _minimumStake = minimumLockAmount_;
        emit UpdateMinimumStake(minimumLockAmount_);
    }

    /**
     * TODO: do we want this generalized transfer function?
     */
    function reallocate(uint256 tokenId, uint256 amount, address to) external onlyRole(LICENSE_ADMIN_ROLE) {
        require(_licenseLockUp[tokenId] <= amount, INVALID_PARAM);

        _licenseLockUp[tokenId] -= amount;

        _dimoToken.transfer(to, amount);
        emit AssetForfeit(tokenId, amount);
    }

    /**
     * in case funds get send to this contract as part of a donation attack, etc
     */
    function adminWithdraw(uint256 amount, address to) external onlyRole(LICENSE_ADMIN_ROLE) {
        //TODO: only able to withdraw the difference btwn total lock, and balance of this contract.
        _dimoToken.transfer(to, amount);
    }

    /**
     */
    function burnLockedFunds(uint256 tokenId, uint256 amount) external onlyRole(LICENSE_ADMIN_ROLE) {
        require(_licenseLockUp[tokenId] >= amount, INVALID_PARAM);

        _licenseLockUp[tokenId] -= amount;

        _dimoToken.burn(address(this), amount);
        emit AssetForfeit(tokenId, amount);
    }

    /**
     */
    function freeze(uint256 tokenId, bool frozen) external onlyRole(LICENSE_ADMIN_ROLE) {
        _licenseLockUpFrozen[tokenId] = frozen;
        emit AssetFreezeUpdate(tokenId, _licenseLockUp[tokenId], frozen);
    }

}
