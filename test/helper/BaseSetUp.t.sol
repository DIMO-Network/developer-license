// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {TwapV3} from "../../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccountBeacon} from "../../src/licenseAccount/DimoDeveloperLicenseAccountBeacon.sol";
import {LicenseAccountFactoryBeacon} from "../../src/licenseAccount/LicenseAccountFactoryBeacon.sol";

contract BaseSetUp is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    bytes32 constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    ERC20 public dimoToken;
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
        dimoToken = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        address laf = _deployLicenseAccountFactory(_admin);

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
                    laf,
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

        LicenseAccountFactoryBeacon(laf).setDevLicenseDimo(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);
    }

    function _deployLicenseAccountFactory(address admin) private returns (address laf) {
        address devLicenseAccountTemplate = address(new DimoDeveloperLicenseAccountBeacon());
        address beacon = address(new UpgradeableBeacon(devLicenseAccountTemplate, admin));

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxyLaf = Upgrades.deployUUPSProxy(
            "LicenseAccountFactoryBeacon.sol", abi.encodeCall(LicenseAccountFactoryBeacon.initialize, (beacon)), opts
        );

        laf = address(LicenseAccountFactoryBeacon(proxyLaf));
    }
}
