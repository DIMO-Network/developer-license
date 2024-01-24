// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDimoToken {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}