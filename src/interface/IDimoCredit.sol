// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDimoCredit {
    function receiver() external view returns (address);
    function dimoCreditRate() external view returns (uint256);
    function burn(address from, uint256 amount) external;
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}