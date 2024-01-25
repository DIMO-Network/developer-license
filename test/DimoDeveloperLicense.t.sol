// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {MockDimoToken} from "./mock/MockDimoToken.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

//forge test --match-path ./test/DimoDeveloperLicense.t.sol -vv
contract DimoDeveloperLicenseTest is Test {

    MockDimoToken dimoToken;
    DimoDeveloperLicense license;

    function setUp() public {
        LicenseAccountFactory laf = new LicenseAccountFactory();
        
        dimoToken = new MockDimoToken();
        license = new DimoDeveloperLicense(address(laf), address(dimoToken), 10_000 ether);

        laf.setLicense(address(license));

        dimoToken.approve(address(license), 10_000 ether);
    }

    function test_mintLicenseSuccess() public {
        
        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.LicenseMinted(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.mint("vehicle_genius");
        assertEq(tokenId, 1);

        assertEq(license.ownerOf(tokenId), address(this));
        assertEq(dimoToken.balanceOf(address(license)), 10_000 ether);
    }

    function test_developerLicenseAccount() public {

        uint256 privateKey = 0x1337;
        address user = vm.addr(privateKey);

        dimoToken.mint(user, 10_000 ether);

        vm.startPrank(user);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId, address accountAddress) = license.mint("solala");
        license.enableSigner(tokenId, user);
        vm.stopPrank();

        bool signer = license.isSigner(tokenId, user);
        console2.log("signer: %s", signer);

        bytes32 hashValue = keccak256(
            abi.encodePacked(
                keccak256(
                    "\x19Ethereum Signed Message:\n32"
                ),
                keccak256("Hello World")
            )   
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hashValue);
        bytes memory signature = abi.encodePacked(r, s, v); 
        bytes4 output = DimoDeveloperLicenseAccount(accountAddress).isValidSignature(hashValue, signature);
        //0x1626ba7e
        console2.logBytes4(output);
        assertEq(IERC1271.isValidSignature.selector, output);
    }

    function test_existsLocked() public {
        (uint256 tokenId,) = license.mint("test");

        bool locked = license.locked(tokenId);
        assertEq(locked, true);

        vm.expectRevert("DimoDeveloperLicense: invalid tokenId");
        license.locked(300);
    }

    
}
