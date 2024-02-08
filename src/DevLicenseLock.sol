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

    event Deposit(uint256 indexed tokenId, address indexed user, uint256 amount);
    event Withdraw(uint256 indexed tokenId, address indexed user, uint256 amount);

    /* * */

    mapping(uint256 => mapping(address => uint256)) private _licenseLockUpDeposit;
    mapping(uint256 => uint256) private _licenseLockUpTotal;

    constructor(
        address laf_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_
    ) DevLicenseCore(laf_, provider_, dimoTokenAddress_, dimoCreditAddress_, licenseCostInUsd_) {
    }

    function deposit(uint256 tokenId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        //require that they're a validSigner...
        isSigner(tokenId, msg.sender);

        _dimoToken.transferFrom(msg.sender, address(this), amount);

        _licenseLockUpDeposit[tokenId][msg.sender] += amount;
        _licenseLockUpTotal[tokenId] += amount;

        emit Deposit(tokenId, msg.sender, amount);
    }

    function withdraw(uint256 tokenId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(_licenseLockUpDeposit[tokenId][msg.sender] >= amount, "Insufficient balance to withdraw");

        _licenseLockUpDeposit[tokenId][msg.sender] -= amount;
        _licenseLockUpTotal[tokenId] -= amount;

        emit Withdraw(tokenId, msg.sender, amount);
    }

    function balanceOfLockUpUser(uint256 tokenId, address user) public view returns (uint256 balance) {
        return _licenseLockUpDeposit[tokenId][user];
    }

    function balanceOfLockUpLicense(uint256 tokenId) public view returns (uint256 balance) {
        return _licenseLockUpTotal[tokenId];
    }

}
