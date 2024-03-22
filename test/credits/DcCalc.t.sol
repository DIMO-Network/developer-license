// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";


import {DimoCredit} from "../../src/DimoCredit.sol";

//forge test --match-path ./test/credits/DcCalc.t.sol -vv
contract DcCalcTest is Test {

    DimoCredit dc; 

    function setUp() public {
        
        
        dc = new DimoCredit();
    }
    
    function test_xxx() public {
        
    }

   
   
}
