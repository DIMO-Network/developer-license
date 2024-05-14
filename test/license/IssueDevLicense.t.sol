// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {DevLicenseCore} from "../../src/DevLicenseCore.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";

import {BaseSetUp} from "../helper/BaseSetUp.t.sol";

//forge test --match-path ./test/license/IssueDevLicense.t.sol -vv
contract IssueDevLicenseTest is BaseSetUp {
    function setUp() public {
        _setUp();
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));
    }

    function test_issueInDimoSuccess() public {
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setReceiverAddress(_receiver);

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, address(this), address(0));

        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        (uint256 amountUsdPerToken,) = provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / amountUsdPerToken) * 1 ether;
        assertEq(dimoToken.balanceOf(_receiver), tokenTransferAmount);
    }

    function test_issueInDimoSuccess_emitLicenseAliasSet() public {
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setReceiverAddress(_receiver);

        vm.expectEmit();
        emit DevLicenseCore.LicenseAliasSet(1, LICENSE_ALIAS);

        license.issueInDimo(LICENSE_ALIAS);
    }

    function test_issueInDimoSuccess_revertAliasAlreadySet() public {
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setReceiverAddress(_receiver);

        license.issueInDimo(LICENSE_ALIAS);

        vm.expectRevert(abi.encodeWithSelector(DevLicenseCore.AliasAlreadyInUse.selector, LICENSE_ALIAS));
        license.issueInDimo(LICENSE_ALIAS);
    }

    /**
     * @dev We send $DIMO to the DC _receiver
     */
    function test_issueInDimoSenderSuccess() public {
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setReceiverAddress(_receiver);

        (uint256 amountUsdPerToken,) = provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / amountUsdPerToken) * 1 ether;
        deal(address(dimoToken), _licenseHolder, tokenTransferAmount);
        vm.startPrank(_licenseHolder);
        dimoToken.approve(address(license), tokenTransferAmount);
        vm.stopPrank();

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, _licenseHolder, address(0));

        (uint256 tokenId,) = license.issueInDimo(_licenseHolder, LICENSE_ALIAS);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), _licenseHolder);
        assertEq(dimoToken.balanceOf(_receiver), tokenTransferAmount);
    }

    function test_issueInDimoSenderSuccess_emitLicenseAliasSet() public {
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setReceiverAddress(_receiver);

        (uint256 amountUsdPerToken,) = provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / amountUsdPerToken) * 1 ether;
        deal(address(dimoToken), _licenseHolder, tokenTransferAmount);
        vm.startPrank(_licenseHolder);
        dimoToken.approve(address(license), tokenTransferAmount);
        vm.stopPrank();

        vm.expectEmit();
        emit DevLicenseCore.LicenseAliasSet(1, LICENSE_ALIAS);

        license.issueInDimo(_licenseHolder, LICENSE_ALIAS);
    }

    function test_issueInDc() public {
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / dimoCredit.dimoCreditRate()) * 1 ether;

        dimoToken.approve(address(dimoCredit), 1_000_000 ether);
        dimoCredit.mint(address(this), tokenTransferAmount, "");

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, address(this), address(0));

        (uint256 tokenId,) = license.issueInDc(address(this), LICENSE_ALIAS);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));
    }

    function test_issueInDc_emitLicenseAliasSet() public {
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / dimoCredit.dimoCreditRate()) * 1 ether;

        dimoToken.approve(address(dimoCredit), 1_000_000 ether);
        dimoCredit.mint(address(this), tokenTransferAmount, "");

        vm.expectEmit();
        emit DevLicenseCore.LicenseAliasSet(1, LICENSE_ALIAS);

        license.issueInDc(address(this), LICENSE_ALIAS);
    }

    function test_issueInDcSenderSuccess() public {
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / dimoCredit.dimoCreditRate()) * 1 ether;

        deal(address(dimoToken), _licenseHolder, 1_000_000 ether);
        vm.startPrank(_licenseHolder);
        dimoToken.approve(address(dimoCredit), tokenTransferAmount);
        vm.stopPrank();

        //dimoCredit.mintAmountDc(_licenseHolder, tokenTransferAmount, "");

        dimoCredit.mint(_licenseHolder, tokenTransferAmount, "");

        //assertEq(dimoCredit.balanceOf(_licenseHolder), tokenTransferAmount);

        vm.expectEmit(true, true, false, false);
        emit DevLicenseDimo.Issued(1, _licenseHolder, address(0));

        (uint256 tokenId,) = license.issueInDc(_licenseHolder, LICENSE_ALIAS);

        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), _licenseHolder);
        // assertEq(dimoCredit.balanceOf(_licenseHolder), 0);
    }

    function test_issueInDcSender_emitLicenseAliasSet() public {
        uint256 tokenTransferAmount = (license._licenseCostInUsd1e18() / dimoCredit.dimoCreditRate()) * 1 ether;

        deal(address(dimoToken), _licenseHolder, 1_000_000 ether);
        vm.startPrank(_licenseHolder);
        dimoToken.approve(address(dimoCredit), tokenTransferAmount);
        vm.stopPrank();

        //dimoCredit.mintAmountDc(_licenseHolder, tokenTransferAmount, "");

        dimoCredit.mint(_licenseHolder, tokenTransferAmount, "");

        //assertEq(dimoCredit.balanceOf(_licenseHolder), tokenTransferAmount);

        vm.expectEmit();
        emit DevLicenseCore.LicenseAliasSet(1, LICENSE_ALIAS);

        license.issueInDc(_licenseHolder, LICENSE_ALIAS);
    }
}
