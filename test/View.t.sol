// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {TwapV3} from "../src/provider/TwapV3.sol";

import {DimoCredit} from "../src/DimoCredit.sol";
import {DevLicenseDimo} from "../src/DevLicenseDimo.sol";
import {IDimoToken} from "../src/interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/View.t.sol -vv
contract ViewTest is Test {

    IDimoToken dimoToken;
    DimoCredit dimoCredit;

    DevLicenseDimo license;
    NormalizedPriceProvider provider;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        provider = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        dimoCredit = new DimoCredit("NAME", "SYMBOL", 18, address(0x123), address(provider));
        LicenseAccountFactory laf = new LicenseAccountFactory();
        license = new DevLicenseDimo(
            address(laf), 
            address(provider), 
            address(dimoToken), 
            address(dimoCredit),
            100
        );
        laf.setLicense(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);
    }

    function test_existsLocked() public {
        (uint256 tokenId,) = license.issueInDimo();
        bool locked = license.locked(tokenId);
        assertEq(locked, true);
        vm.expectRevert("DevLicenseDimo: invalid tokenId");
        license.locked(300);
    }

    function test_ownerOfSuccess() public {
        (uint256 tokenId,) = license.issueInDimo();
        assertEq(license.ownerOf(tokenId), address(this));
    }

    function test_ownerOfFail() public {
        vm.expectRevert("DevLicenseDimo: invalid tokenId");
        license.ownerOf(type(uint256).max);
    }

    function test_name() public {
        string memory name = license.name();
        //console2.log("name: %s", name);
        assertEq(name, "DIMO Developer License");
    }

    function test_symbol() public {
        string memory symbol = license.symbol();
        //console2.log("symbol: %s", symbol);
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
        (uint256 tokenId, address clientId) = license.issueInDimo();
        license.enableSigner(tokenId, signer00);
        vm.stopPrank();

        bool isSigner00 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer00);
        assertEq(isSigner00, true);

        bool isSigner01 = IDimoDeveloperLicenseAccount(clientId).isSigner(signer01);
        assertEq(isSigner01, false);  
    }

    //do it for DC this time...
    function test_isSignerExpire() public {
         
    }

    function test_supportsInterface() public {
         
    }

    function test_periodValidity() public {
         
    }

    function test_licenseCostInUsd() public {
         
    }
    
}
