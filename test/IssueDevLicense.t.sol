// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";
import {DevLicenseDimo} from "../src/DevLicenseDimo.sol";

import {BaseSetUp} from "./helper/BaseSetUp.t.sol";

//forge test --match-path ./test/IssueDevLicense.t.sol -vv
contract IssueDevLicenseTest is BaseSetUp {

    function setUp() public {
        _setUp();
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));
    }

    /**
     */
    function test_issueInDimoSuccess() public {   
        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, address(this), address(0));

        (uint256 tokenId,) = license.issueInDimo();
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        (uint256 amountUsdPerToken,) = provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = 1 ether / (amountUsdPerToken * 100);
        //console2.log("tokenTransferAmount %s", tokenTransferAmount);
        assertEq(dimoToken.balanceOf(dimoCredit.receiver()), tokenTransferAmount);
    }

    /**
     * TODO: Do we want to send $DIMO to the DC receiver? 
     */
    function test_issueInDimoSenderSuccess() public {
        address licenseHolder = address(0x999);

        (uint256 amountUsdPerToken,) = provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = 1 ether / (amountUsdPerToken * 100);
        deal(address(dimoToken), licenseHolder, tokenTransferAmount);
        vm.startPrank(licenseHolder);
        dimoToken.approve(address(license), tokenTransferAmount);
        vm.stopPrank();

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, licenseHolder, address(0));

        (uint256 tokenId,) = license.issueInDimo(licenseHolder);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), licenseHolder);
        assertEq(dimoToken.balanceOf(dimoCredit.receiver()), tokenTransferAmount);
    }

    function test_issueInDc() public {  

        uint256 tokenTransferAmount = dimoCredit.dimoCreditRate() * 100;
        console2.log("tokenTransferAmount %s", tokenTransferAmount); 

        dimoToken.approve(address(dimoCredit), 1_000_000 ether);
        dimoCredit.mintAmountDc(address(this), tokenTransferAmount, "");
        assertEq(dimoCredit.balanceOf(address(this)), tokenTransferAmount);

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, address(this), address(0));

        (uint256 tokenId,) = license.issueInDc(address(this));
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        assertEq(dimoCredit.balanceOf(address(this)), 0);
    }

    function test_issueInDcSenderSuccess() public {
        address licenseHolder = address(0x999);

        uint256 tokenTransferAmount = dimoCredit.dimoCreditRate() * 100;
        
        deal(address(dimoToken), licenseHolder, 1_000_000 ether);
        vm.startPrank(licenseHolder);
        dimoToken.approve(address(dimoCredit), tokenTransferAmount);
        vm.stopPrank();

        dimoCredit.mintAmountDc(licenseHolder, tokenTransferAmount, "");
        assertEq(dimoCredit.balanceOf(licenseHolder), tokenTransferAmount);

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, licenseHolder, address(0));

        (uint256 tokenId,) = license.issueInDc(licenseHolder);

        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), licenseHolder);
        assertEq(dimoCredit.balanceOf(licenseHolder), 0);
    }
    
}
