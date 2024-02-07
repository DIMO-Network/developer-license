// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {IDimoToken} from "./interface/IDimoToken.sol";

/** 
 * 
 */
contract LicenseLockUp {

    event Deposit(uint256 indexed tokenId, address indexed user, uint256 amount);
    event Withdraw(uint256 indexed tokenId, address indexed user, uint256 amount);

    /* * */

    IDimoToken _dimoToken;

    mapping(uint256 => mapping(address => uint256)) private _licenseLockUpDeposit;
    mapping(uint256 => uint256) private _licenseLockUpTotal;

    constructor(address dimoToken_) {

        _dimoToken = IDimoToken(dimoToken_);
    }

    function deposit(uint256 tokenId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        //require that they're a validSigner...

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

    /* * */

}
