// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {ERC20} from "solmate/src/tokens/ERC20.sol";

import {TwapV3} from "../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {IDimoCredit} from "../src/interface/IDimoCredit.sol";
import {DimoCredit} from "../src/DimoCredit.sol";

//forge test --match-path ./test/IssueDevLicenseTest.t.sol -vv
contract IssueDevLicenseTest is Test {

    DimoCredit dc;
    ERC20 dimoToken;
    DimoDeveloperLicense license;
    NormalizedPriceProvider npp;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        dimoToken = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        TwapV3 twap = new TwapV3();
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);

        npp = new NormalizedPriceProvider();
        npp.addOracleSource(address(twap));

        dc = new DimoCredit("NAME", "SYMBOL", 18, address(0x123), address(npp));

        LicenseAccountFactory laf = new LicenseAccountFactory();
        
        license = new DimoDeveloperLicense(
            address(laf), 
            address(npp), 
            address(dimoToken), 
            address(dc), 
            100
        );

        dc.grantRole(keccak256("BURNER_ROLE"), address(license));

        laf.setLicense(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);
    }

    /**
     */
    function test_issueInDimoSuccess() public {   
        vm.expectEmit(true, true, false, false);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), address(0));

        (uint256 tokenId,) = license.issueInDimo();
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        (uint256 amountUsdPerToken,) = npp.getAmountUsdPerToken();
        uint256 tokenTransferAmount = amountUsdPerToken * 100;
        console2.log("tokenTransferAmount %s", tokenTransferAmount);

        assertEq(dimoToken.balanceOf(dc.receiver()), tokenTransferAmount);
    }

    /**
     * TODO: Do we want to send $DIMO to the DC receiver? 
     */
    function test_issueInDimoSenderSuccess() public {
        address licenseHolder = address(0x999);

        (uint256 amountUsdPerToken,) = npp.getAmountUsdPerToken();
        uint256 tokenTransferAmount = amountUsdPerToken * 100;
        deal(address(dimoToken), licenseHolder, tokenTransferAmount);
        vm.startPrank(licenseHolder);
        dimoToken.approve(address(license), tokenTransferAmount);
        vm.stopPrank();

        vm.expectEmit(true, true, false, false);
        emit DimoDeveloperLicense.Issued(1, licenseHolder, address(0), address(0));

        (uint256 tokenId,) = license.issueInDimo(licenseHolder);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), licenseHolder);
        assertEq(dimoToken.balanceOf(dc.receiver()), tokenTransferAmount);
    }

    function test_issueInDc() public {  

        uint256 tokenTransferAmount = dc.dimoCreditRate() * 100;
        console2.log("tokenTransferAmount %s", tokenTransferAmount); 

        dimoToken.approve(address(dc), 1_000_000 ether);
        dc.mintAmountDc(address(this), tokenTransferAmount, "");
        assertEq(dc.balanceOf(address(this)), tokenTransferAmount);

        vm.expectEmit(true, true, false, false);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), address(0));

        (uint256 tokenId,) = license.issueInDc(address(this));
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        assertEq(dc.balanceOf(address(this)), 0);
    }

    function test_issueInDcSenderSuccess() public {
        address licenseHolder = address(0x999);

        uint256 tokenTransferAmount = dc.dimoCreditRate() * 100;
        
        deal(address(dimoToken), licenseHolder, 1_000_000 ether);
        vm.startPrank(licenseHolder);
        dimoToken.approve(address(dc), tokenTransferAmount);
        vm.stopPrank();

        dc.mintAmountDc(licenseHolder, tokenTransferAmount, "");
        assertEq(dc.balanceOf(licenseHolder), tokenTransferAmount);

        vm.expectEmit(true, true, false, false);
        emit DimoDeveloperLicense.Issued(1, licenseHolder, address(0), address(0));

        (uint256 tokenId,) = license.issueInDc(licenseHolder);
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), licenseHolder);
        assertEq(dc.balanceOf(licenseHolder), 0);
    }
    
}
