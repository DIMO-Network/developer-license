// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IDimoToken {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function balanceOf(address _owner) external view returns (uint256 balance);
    function totalSupply() external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool success);
    function burn(address user, uint256 amount) external;
    function grantRole(bytes32 role, address account) external;
}
