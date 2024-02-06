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

//forge test --match-path ./test/DevLicenseTest.t.sol -vv
contract DevLicenseTest is Test {

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
    function test_issueInDimo() public {   
        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.issueInDimo("vehicle_genius");
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        (uint256 amountUsdPerToken,) = npp.getAmountUsdPerToken();
        uint256 tokenTransferAmount = amountUsdPerToken * 100;
        console2.log("tokenTransferAmount %s", tokenTransferAmount);

        assertEq(dimoToken.balanceOf(address(license)), tokenTransferAmount);
    }

    function test_issueInDc() public {  

        uint256 tokenTransferAmount = dc.dataCreditRate() * 100;
        console2.log("tokenTransferAmount %s", tokenTransferAmount); 

        dimoToken.approve(address(dc), 1_000_000 ether);
        dc.mintAmountOut(address(this), tokenTransferAmount, "");
        assertEq(dc.balanceOf(address(this)), tokenTransferAmount);

        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.issueInDc(address(this), "vehicle_genius");
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));

        assertEq(dc.balanceOf(address(this)), 0);
    }
    
}
