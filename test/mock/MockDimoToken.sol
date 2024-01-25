// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockDimoToken is ERC20 {
    constructor() ERC20("DIMO Token", "DIMO") {
        _mint(msg.sender, 1_000_000 ether);
    }

    function mint(address user, uint256 amount) public {
        _mint(user, amount);
    }
}