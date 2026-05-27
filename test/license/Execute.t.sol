// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {console2} from "forge-std/Test.sol";

import {BaseSetUp} from "../helper/BaseSetUp.t.sol";

import {DimoDeveloperLicenseAccount} from "../../src/licenseAccount/DimoDeveloperLicenseAccount.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";

//forge test --match-path ./test/license/Execute.t.sol -vv
contract ExecuteTest is BaseSetUp {
    uint256 tokenId;
    address clientId;
    address owner;

    function setUp() public {
        _setUp();

        owner = address(this);
        (tokenId, clientId) = license.issueInDimo(LICENSE_ALIAS);
    }

    function test_executeAsOwner() public {
        deal(address(dimoToken), clientId, 100 ether);

        bytes memory data = abi.encodeCall(IDimoToken.transfer, (owner, 50 ether));
        DimoDeveloperLicenseAccount(payable(clientId)).execute(address(dimoToken), 0, data);

        assertEq(dimoToken.balanceOf(clientId), 50 ether);
        assertEq(dimoToken.balanceOf(owner), 50 ether);
    }

    function test_executeRevertsForNonOwner() public {
        address notOwner = address(0xdead);

        bytes memory data = abi.encodeCall(IDimoToken.transfer, (notOwner, 1 ether));

        vm.prank(notOwner);
        vm.expectRevert(DimoDeveloperLicenseAccount.Unauthorized.selector);
        DimoDeveloperLicenseAccount(payable(clientId)).execute(address(dimoToken), 0, data);
    }

    function test_executeForwardsValue() public {
        address target = address(0xBEEF);
        vm.deal(clientId, 1 ether);

        DimoDeveloperLicenseAccount(payable(clientId)).execute(target, 0.5 ether, "");

        assertEq(target.balance, 0.5 ether);
        assertEq(clientId.balance, 0.5 ether);
    }

    function test_executeRevertsOnFailedCall() public {
        bytes memory badData = abi.encodeCall(IDimoToken.transfer, (owner, 999_999 ether));

        vm.expectRevert();
        DimoDeveloperLicenseAccount(payable(clientId)).execute(address(dimoToken), 0, badData);
    }

    function test_receiveEth() public {
        vm.deal(owner, 1 ether);
        (bool ok,) = clientId.call{value: 1 ether}("");
        assertTrue(ok);
        assertEq(clientId.balance, 1 ether);
    }
}
