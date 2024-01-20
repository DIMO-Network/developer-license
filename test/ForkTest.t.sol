// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

//forge test --match-path ./test/ForkTest.t.sol -vv
contract ForkTest is Test {

    function setUp() public {
        
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
          
    }

    /**
     * 
     */
    function test_001() public {
    
    }

}