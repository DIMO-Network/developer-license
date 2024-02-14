// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DevLicenseDimo} from "../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {ERC20} from "solmate/src/tokens/ERC20.sol";

import {TwapV3} from "../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {DimoCredit} from "../src/DimoCredit.sol";

//forge test --match-path ./test/View.t.sol -vv
contract ViewTest is Test {

    ERC20 dimoToken;
    DevLicenseDimo license;

    DimoCredit dc;
    NormalizedPriceProvider npp;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        dimoToken = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        LicenseAccountFactory laf = new LicenseAccountFactory();

        npp = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);
        npp.addOracleSource(address(twap));

        dc = new DimoCredit("NAME", "SYMBOL", 18, address(0x123), address(npp));

        license = new DevLicenseDimo(
            address(laf), 
            address(npp), 
            address(dimoToken), 
            address(dc),
            100
        );

        laf.setLicense(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);
    }

    function test_exists() public {
        
    }

    //name
    //symbol
    //isSigner(uint256 tokenId, address signer)
    //ownerOf(uint256 tokenId) 
    //locked(uint256 tokenId)
    //supportsInterface(bytes4 interfaceId)
    //maybe want these also...
    //uint256 public _periodValidity; 
    //uint256 public _licenseCostInUsd;
    
}
