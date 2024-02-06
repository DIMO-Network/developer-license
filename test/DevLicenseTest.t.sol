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

//forge test --match-path ./test/DimoDeveloperLicense.t.sol -vv
contract DimoDeveloperLicenseTest is Test {

    address dimoToken;
    DimoDeveloperLicense license;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        LicenseAccountFactory laf = new LicenseAccountFactory();

        NormalizedPriceProvider npp = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 twapIntervalUsdc = 30 minutes;
        uint32 twapIntervalDimo = 4 minutes; 
        twap.initialize(twapIntervalUsdc, twapIntervalDimo);
        npp.addOracleSource(address(twap));

        license = new DimoDeveloperLicense(address(laf), address(npp), 0xE261D618a959aFfFd53168Cd07D12E37B26761db, 100);

        laf.setLicense(address(license));
        deal(0xE261D618a959aFfFd53168Cd07D12E37B26761db, address(this), 1_000_000 ether);
        ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db).approve(address(license), 1_000_000 ether);
    }

    function test_mintLicenseSuccess() public {
        
        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.issueInDimo("vehicle_genius");
        assertEq(tokenId, 1);

        assertEq(license.ownerOf(tokenId), address(this));
        assertEq(ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db).balanceOf(address(license)), 10_000 ether);
    }
    
}
