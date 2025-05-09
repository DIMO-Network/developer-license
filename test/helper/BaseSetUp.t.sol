// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {TwapV3} from "../../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccount} from "../../src/licenseAccount/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../../src/licenseAccount/LicenseAccountFactory.sol";

contract BaseSetUp is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    string constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    IDimoToken public dimoToken;
    DevLicenseDimo public license;

    DimoCredit public dimoCredit;
    NormalizedPriceProvider public provider;

    address _receiver;
    address _admin;
    address _licenseHolder;

    function _setUp() public {
        _receiver = address(0x123);
        _admin = address(0x1);
        _licenseHolder = address(0x999);

        vm.createSelectFork("https://polygon-rpc.com", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        LicenseAccountFactory laf = _deployLicenseAccountFactory(_admin);

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));

        TwapV3 twap = new TwapV3();
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this));

        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes;
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        uint256 licenseCostInUsd1e18 = 100 ether;

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxyDc = Upgrades.deployUUPSProxy(
            "DimoCredit.sol",
            abi.encodeCall(
                DimoCredit.initialize,
                (DC_NAME, DC_SYMBOL, address(dimoToken), _receiver, address(provider), DC_VALIDATION_PERIOD, DC_RATE)
            ),
            opts
        );

        dimoCredit = DimoCredit(proxyDc);

        address proxyDl = Upgrades.deployUUPSProxy(
            "DevLicenseDimo.sol",
            abi.encodeCall(
                DevLicenseDimo.initialize,
                (
                    _receiver,
                    address(laf),
                    address(provider),
                    address(dimoToken),
                    address(dimoCredit),
                    licenseCostInUsd1e18,
                    IMAGE_SVG,
                    METADATA_DESCRIPTION
                )
            ),
            opts
        );

        license = DevLicenseDimo(proxyDl);

        laf.grantRole(keccak256("ADMIN_ROLE"), _admin);

        vm.startPrank(_admin);
        laf.setDevLicenseDimo(address(license));
        vm.stopPrank();

        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);

        vm.startPrank(0xCED3c922200559128930180d3f0bfFd4d9f4F123); // Foundation
        dimoToken.grantRole(keccak256("BURNER_ROLE"), address(dimoCredit));
        vm.stopPrank();
    }

    function _deployLicenseAccountFactory(address admin) private returns (LicenseAccountFactory laf) {
        address devLicenseAccountTemplate = address(new DimoDeveloperLicenseAccount());
        address beacon = address(new UpgradeableBeacon(devLicenseAccountTemplate, admin));

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxyLaf = Upgrades.deployUUPSProxy(
            "LicenseAccountFactory.sol", abi.encodeCall(LicenseAccountFactory.initialize, (beacon)), opts
        );

        laf = LicenseAccountFactory(proxyLaf);
    }
}
