// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";

import {BaseSetUp} from "./helper/BaseSetUp.t.sol";

//forge test --match-path ./test/Integration.t.sol -vv
contract IntegrationTest is BaseSetUp {

    //ERC20 public dimoToken;
    //DevLicenseDimo public license;
    //DimoCredit public dc;
    //NormalizedPriceProvider public npp;

    function setUp() public {
        _setUp();
    }

    function test_integration00() public {   

    }

    
}
