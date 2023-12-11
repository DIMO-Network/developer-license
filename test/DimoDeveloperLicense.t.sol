// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "forge-std/console.sol";

contract MockDimoToken is ERC20, Test {
    constructor() ERC20("DIMO Token", "DIMO") {
        _mint(msg.sender, 1_000_000 ether);
    }
}

contract CounterTest is Test {
    function test_MintLicenseSuccess() public {
        MockDimoToken dimoToken = new MockDimoToken();
        DimoDeveloperLicense license = new DimoDeveloperLicense(address(dimoToken), 10_000 ether);

        dimoToken.approve(address(license), 10_000 ether);

        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.LicenseMinted(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.mint("vehicle_genius");
        assertEq(tokenId, 1);

        assertEq(license.ownerOf(tokenId), address(this));
        assertEq(dimoToken.balanceOf(address(license)), 10_000 ether);
    }
}
