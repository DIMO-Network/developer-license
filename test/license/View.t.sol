// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {console2} from "forge-std/Test.sol";
import {IERC721} from "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC5192} from "../../src/interface/IERC5192.sol";
import {IERC721Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {TestOracleSource} from "../helper/TestOracleSource.sol";

import {IDevLicenseErrors} from "../../src/interface/IDevLicenseErrors.sol";
import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";
import {DevLicenseCore} from "../../src/DevLicenseCore.sol";

import {BaseSetUp} from "../helper/BaseSetUp.t.sol";

//forge test --match-path ./test/license/View.t.sol -vv
contract ViewTest is BaseSetUp {
    uint256 _licenseCostInUsd;

    function setUp() public {
        _setUp();
        _licenseCostInUsd = 100 ether;
    }

    function test_existsLocked() public {
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        bool locked = license.locked(tokenId);
        assertEq(locked, true);

        vm.expectRevert(abi.encodeWithSelector(IDevLicenseErrors.NonexistentToken.selector, 99));
        license.locked(99);
    }

    function test_ownerOfSuccess() public {
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        assertEq(license.ownerOf(tokenId), address(this));
    }

    function test_ownerOfFail() public {
        vm.expectRevert(abi.encodeWithSelector(IDevLicenseErrors.NonexistentToken.selector, type(uint256).max));
        license.ownerOf(type(uint256).max);
    }

    function test_name() public view {
        string memory name = license.name();
        assertEq(name, "DIMO Developer License");
    }

    function test_symbol() public view {
        string memory symbol = license.symbol();
        assertEq(symbol, "DLX");
    }

    function test_isSignerSucceedFail() public {
        address admin = address(0x1337);
        deal(address(dimoToken), admin, 1_000_000 ether);

        vm.startPrank(admin);
        dimoToken.approve(address(license), 1_000_000 ether);
        vm.stopPrank();

        address signer00 = address(0x123);
        address signer01 = address(0x456);

        vm.startPrank(admin);
        (uint256 tokenId, address clientId) = license.issueInDimo(LICENSE_ALIAS);
        license.enableSigner(tokenId, signer00);
        vm.stopPrank();

        bool isSigner00 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer00);
        assertEq(isSigner00, true);

        bool isSigner01 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer01);
        assertEq(isSigner01, false);
    }

    function test_isSignerExpired() public {
        address to = address(0x1989);
        uint256 amountIn = 1 ether;

        TestOracleSource testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1000 ether);
        provider.addOracleSource(address(testOracleSource));
        provider.setPrimaryOracleSource(1);

        deal(address(dimoToken), to, amountIn);
        vm.startPrank(to);
        dimoToken.approve(address(dimoCredit), amountIn);
        dimoCredit.mintInDimo(to, amountIn);
        vm.stopPrank();

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setLicenseCost(1 ether);
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        (uint256 tokenId, address clientId) = license.issueInDc(to, LICENSE_ALIAS);
        ///@notice ^mint license to a user other than the caller (using DC)

        address signer = address(0x123);

        vm.startPrank(to);
        license.enableSigner(tokenId, signer);
        vm.stopPrank();

        bool isSigner00 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner00, true);

        vm.warp(block.timestamp + 366 days);

        bool isSigner01 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner01, false);
    }

    function test_enableSignerEvent() public {
        address to = address(0x1989);
        uint256 amountIn = 1 ether;

        TestOracleSource testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1000 ether);
        provider.addOracleSource(address(testOracleSource));
        provider.setPrimaryOracleSource(1);

        deal(address(dimoToken), to, amountIn);
        vm.startPrank(to);
        dimoToken.approve(address(dimoCredit), amountIn);
        dimoCredit.mintInDimo(to, amountIn);
        vm.stopPrank();

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setLicenseCost(1 ether);
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        (uint256 tokenId,) = license.issueInDc(to, LICENSE_ALIAS);
        ///@notice ^mint license to a user other than the caller (using DC)

        address signer = address(0x123);

        vm.expectEmit();
        emit DevLicenseCore.SignerEnabled(tokenId, signer);

        vm.startPrank(to);
        license.enableSigner(tokenId, signer);
        vm.stopPrank();
    }

    function test_disableSigner() public {
        address to = address(0x1989);
        uint256 amountIn = 1 ether;

        TestOracleSource testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1000 ether);
        provider.addOracleSource(address(testOracleSource));
        provider.setPrimaryOracleSource(1);

        deal(address(dimoToken), to, amountIn);
        vm.startPrank(to);
        dimoToken.approve(address(dimoCredit), amountIn);
        dimoCredit.mintInDimo(to, amountIn);
        vm.stopPrank();

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setLicenseCost(1 ether);
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        (uint256 tokenId, address clientId) = license.issueInDc(to, LICENSE_ALIAS);
        ///@notice ^mint license to a user other than the caller (using DC)

        address signer = address(0x123);

        vm.startPrank(to);
        license.enableSigner(tokenId, signer);
        vm.stopPrank();

        bool isSigner = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner, true);

        vm.startPrank(to);
        license.disableSigner(tokenId, signer);
        vm.stopPrank();

        isSigner = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner, false);
    }

    function test_disableSignerEvent() public {
        address to = address(0x1989);
        uint256 amountIn = 1 ether;

        TestOracleSource testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1000 ether);
        provider.addOracleSource(address(testOracleSource));
        provider.setPrimaryOracleSource(1);

        deal(address(dimoToken), to, amountIn);
        vm.startPrank(to);
        dimoToken.approve(address(dimoCredit), amountIn);
        dimoCredit.mintInDimo(to, amountIn);
        vm.stopPrank();

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setLicenseCost(1 ether);
        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        (uint256 tokenId,) = license.issueInDc(to, LICENSE_ALIAS);
        ///@notice ^mint license to a user other than the caller (using DC)

        address signer = address(0x123);

        vm.startPrank(to);
        license.enableSigner(tokenId, signer);

        vm.expectEmit();
        emit DevLicenseCore.SignerDisabled(tokenId, signer);

        license.disableSigner(tokenId, signer);
        vm.stopPrank();
    }

    function test_supportsInterface() public view {
        bytes4 interface721 = type(IERC721).interfaceId;
        bool supports721 = license.supportsInterface(interface721);
        assertEq(supports721, true);

        bytes4 interface5192 = type(IERC5192).interfaceId;
        bool supports5192 = license.supportsInterface(interface5192);
        assertEq(supports5192, true);

        bytes4 interface721Metadata = type(IERC721Metadata).interfaceId;
        bool supports721Metadata = license.supportsInterface(interface721Metadata);
        assertEq(supports721Metadata, true);
    }

    function test_periodValidity() public {
        license.grantRole(license.LICENSE_ADMIN_ROLE(), address(this));

        address signer = address(0x123);
        (uint256 tokenId, address clientId) = license.issueInDimo(LICENSE_ALIAS);
        license.enableSigner(tokenId, signer);

        uint256 periodValidity00 = 365 days;
        assertEq(license.periodValidity(), periodValidity00);

        bool isSigner00 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner00, true);

        uint256 periodValidity01 = 1;
        license.setPeriodValidity(periodValidity01);

        vm.warp(block.timestamp + 2);

        bool isSigner01 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer);
        assertEq(isSigner01, false);

        assertEq(license.periodValidity(), periodValidity01);
    }

    function test_licenseCostInUsd() public {
        license.grantRole(license.LICENSE_ADMIN_ROLE(), address(this));

        uint256 licenseCostInUsd00 = license.licenseCostInUsd1e18();

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), address(this));
        license.setLicenseCost(0.5 ether);

        assertEq(licenseCostInUsd00, _licenseCostInUsd);

        uint256 licenseCostInUsd01 = 0.1 ether;
        license.setLicenseCost(licenseCostInUsd01);

        address user = address(0x1999);

        vm.startPrank(user);
        dimoToken.approve(address(license), 0.05 ether);
        license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();

        license.setLicenseCost(1_000_000 ether);

        vm.startPrank(user);
        vm.expectRevert("ERC20: insufficient allowance");
        license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();
    }

    function test_setLicenseAlias() public {
        bytes32 NEW_LICENSE_ALIAS = "new license alias";

        license.issueInDimo(LICENSE_ALIAS);

        bytes32 aliasBefore = license.getLicenseAliasByTokenId(1);
        uint256 tokenIdBefore = license.getTokenIdByLicenseAlias(LICENSE_ALIAS);
        assertEq(aliasBefore, LICENSE_ALIAS);
        assertEq(tokenIdBefore, 1);

        license.setLicenseAlias(1, NEW_LICENSE_ALIAS);
        bytes32 aliasAfter = license.getLicenseAliasByTokenId(1);
        uint256 tokenIdAfter = license.getTokenIdByLicenseAlias(NEW_LICENSE_ALIAS);
        assertEq(aliasAfter, NEW_LICENSE_ALIAS);
        assertEq(tokenIdAfter, 1);
    }

    function test_setLicenseAlias_revertNotTokenOwner() public {
        bytes32 NEW_LICENSE_ALIAS = "new license alias";

        license.issueInDimo(LICENSE_ALIAS);

        bytes32 aliasBefore = license.getLicenseAliasByTokenId(1);
        assertEq(aliasBefore, LICENSE_ALIAS);

        vm.startPrank(address(0x999));
        vm.expectRevert(abi.encodeWithSelector(IDevLicenseErrors.InvalidSender.selector, address(0x999)));
        license.setLicenseAlias(1, NEW_LICENSE_ALIAS);
        vm.stopPrank();
    }

    function test_setLicenseAlias_revertAliasAlreadySet() public {
        license.issueInDimo(LICENSE_ALIAS);

        vm.expectRevert(abi.encodeWithSelector(IDevLicenseErrors.AliasAlreadyInUse.selector, LICENSE_ALIAS));
        license.issueInDimo(LICENSE_ALIAS);
    }
}
