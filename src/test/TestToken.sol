// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20 {
    
    constructor() ERC20("TestToken", "TT") {
        _mint(msg.sender, 10_000);
    }

    function mint(address account, uint256 value) internal {
        _mint(account, value);
    }
}