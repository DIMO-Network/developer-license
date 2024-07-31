// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {TestOracleSource} from "../helper/TestOracleSource.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccount} from "../../src/licenseAccount/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../../src/licenseAccount/LicenseAccountFactory.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/math/CalculationsDc.t.sol -vv
contract CalculationsDcTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    bytes32 constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    DimoCredit dimoCredit;
    IDimoToken dimoToken;
    DevLicenseDimo license;

    NormalizedPriceProvider provider;
    TestOracleSource testOracleSource;

    uint256 licenseCostInUsd;

    address _receiver;
    address _admin;

    function setUp() public {
        _receiver = address(0x123);
        _admin = address(0x1);

        vm.createSelectFork("https://polygon-rpc.com", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        testOracleSource = new TestOracleSource();
        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        provider.addOracleSource(address(testOracleSource));

        LicenseAccountFactory factory = _deployLicenseAccountFactory(_admin);

        licenseCostInUsd = 0;
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
                    address(factory),
                    address(provider),
                    address(dimoToken),
                    address(dimoCredit),
                    licenseCostInUsd,
                    IMAGE_SVG,
                    METADATA_DESCRIPTION
                )
            ),
            opts
        );

        license = DevLicenseDimo(proxyDl);

        factory.grantRole(keccak256("ADMIN_ROLE"), _admin);

        vm.startPrank(_admin);
        factory.setDevLicenseDimo(address(license));
        vm.stopPrank();

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

    function test_setDimoCreditRate() public {
        dimoCredit.grantRole(keccak256("DC_ADMIN_ROLE"), _admin);

        vm.startPrank(_admin);
        dimoCredit.setDimoCreditRate(1 ether);
        vm.stopPrank();
    }

    function test_calcOneToOne() public {
        dimoCredit.grantRole(keccak256("DC_ADMIN_ROLE"), _admin);

        vm.startPrank(_admin);
        dimoCredit.setDimoCreditRate(1 ether);
        vm.stopPrank();

        address to = vm.addr(0x123);

        uint256 licenseCostUpdate = 1 ether;
        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), _admin);
        vm.startPrank(_admin);
        license.setLicenseCost(licenseCostUpdate);
        vm.stopPrank();

        testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1 ether);

        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        provider.addOracleSource(address(testOracleSource));
        provider.setPrimaryOracleSource(1);

        uint256 amountIn = 1 ether;

        deal(address(dimoToken), to, amountIn);
        vm.startPrank(to);
        dimoToken.approve(address(dimoCredit), amountIn);
        dimoCredit.mintInDimo(to, amountIn);
        vm.stopPrank();

        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        vm.startPrank(to);
        (uint256 tokenId,) = license.issueInDc(LICENSE_ALIAS);
        vm.stopPrank();

        assertEq(tokenId, 1);
    }
}
