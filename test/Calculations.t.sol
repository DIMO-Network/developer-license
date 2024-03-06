// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";

import {BaseSetUp} from "./helper/BaseSetUp.t.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {IDimoDeveloperLicenseAccount} from "../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/Calculations.t.sol -vv
contract CalculationsTest is BaseSetUp {

    function setUp() public {
        _setUp();
    }

    function test_licenseCostInUsd() public {

        (uint256 tokenId,) = license.issueInDimo();

        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

    }

}
