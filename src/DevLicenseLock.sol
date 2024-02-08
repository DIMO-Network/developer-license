// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {IDimoToken} from "./interface/IDimoToken.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {DevLicenseCore} from "./DevLicenseCore.sol";

/**
 * 
 * TODO: minimum stake...
 * 
 * https://dimo.zone/news/on-dimo-tokenomics
 */
contract DevLicenseLock is DevLicenseCore {

    uint256 public _minimumStake;

    /* * */

    mapping(uint256 => mapping(address => uint256)) public _licenseLockUpDeposit;
    mapping(uint256 => uint256) public _licenseLockUpTotal;
    mapping(uint256 => bool) public _licenseLockUpFrozen;

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    event UpdateMinimumStake(uint256 amount);
    event AdminSanction(uint256 tokenId, uint256 amount);
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
     */
    function deposit(uint256 tokenId, uint256 amount) public {
        require(amount > _minimumStake, INVALID_PARAM);
        require(isSigner(tokenId, msg.sender), INVALID_MSG_SENDER);

        _dimoToken.transferFrom(msg.sender, address(this), amount);

        _licenseLockUpDeposit[tokenId][msg.sender] += amount;
        _licenseLockUpTotal[tokenId] += amount;

        emit Deposit(tokenId, msg.sender, amount);
    }

    function withdraw(uint256 tokenId, uint256 amount) public {
        require(amount > 0, INVALID_PARAM);
        require(_licenseLockUpDeposit[tokenId][msg.sender] >= amount, INVALID_PARAM);
        require(!_licenseLockUpFrozen[tokenId], "DevLicenseDimo: funds inaccessible");

        _licenseLockUpDeposit[tokenId][msg.sender] -= amount;
        _licenseLockUpTotal[tokenId] -= amount;

        emit Withdraw(tokenId, msg.sender, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            Info Functions
    //////////////////////////////////////////////////////////////*/

    function balanceOfLockUpUser(uint256 tokenId, address user) public view returns (uint256 balance) {
        return _licenseLockUpDeposit[tokenId][user];
    }

    function balanceOfLockUpLicense(uint256 tokenId) public view returns (uint256 balance) {
        bool frozen = _licenseLockUpFrozen[tokenId];
        if(frozen){
            balance = 0;
        } else {
            balance = _licenseLockUpTotal[tokenId];
        }
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * TODO: prolly should be a role for this instead of 'onlyOwner'
     */

    function setMinimumStake(uint256 minimumStake_) public onlyOwner {
        _minimumStake = minimumStake_;
        emit UpdateMinimumStake(_minimumStake);
    }

    /**
     * TODO: do we want this generalized transfer function, or 
     * do we want to be more restrictive with what we can do...
     */
    function reallocate(uint256 tokenId, uint256 amount) public onlyOwner {
        require(_licenseLockUpDeposit[tokenId][msg.sender] >= amount, INVALID_PARAM);

        _licenseLockUpDeposit[tokenId][msg.sender] -= amount;
        _licenseLockUpTotal[tokenId] -= amount;

        _dimoToken.transferFrom(address(this), msg.sender, amount);
        emit AdminSanction(tokenId, amount);
    }

    /**
     * 
     */
    function burn(uint256 tokenId, uint256 amount) public onlyOwner {
        require(_licenseLockUpDeposit[tokenId][msg.sender] >= amount, INVALID_PARAM);

        _licenseLockUpDeposit[tokenId][msg.sender] -= amount;
        _licenseLockUpTotal[tokenId] -= amount;

        _dimoToken.burn(address(this), amount);
        emit AdminSanction(tokenId, amount);
    }

    /**
     * 
     */
    function freeze(uint256 tokenId, bool status) public onlyOwner {
        if(status) {
            emit AdminSanction(tokenId, _licenseLockUpTotal[tokenId]);
        }
        _licenseLockUpFrozen[tokenId] = status;
    }

}
