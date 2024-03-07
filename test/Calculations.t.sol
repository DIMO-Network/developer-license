// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {TestOracleSource} from "./helper/TestOracleSource.sol";
import {DimoCredit} from "../src/DimoCredit.sol";
import {IDimoToken} from "../src/interface/IDimoToken.sol";
import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {IDimoDeveloperLicenseAccount} from "../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/Calculations.t.sol -vv
contract CalculationsTest is Test {

    DimoCredit dimoCredit;
    IDimoToken dimoToken;
    NormalizedPriceProvider provider;
    TestOracleSource testOracleSource;

    address receiver;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        testOracleSource = new TestOracleSource();
        provider = new NormalizedPriceProvider();
        provider.addOracleSource(address(testOracleSource));

        receiver = address(0x123);

        dimoCredit = new DimoCredit(receiver, address(provider));
    }

    function test_licenseCostInUsd() public {

        // (uint256 tokenId,) = license.issueInDimo();

        // assertEq(tokenId, 1);
        // assertEq(license.ownerOf(tokenId), address(this));

    }

}
