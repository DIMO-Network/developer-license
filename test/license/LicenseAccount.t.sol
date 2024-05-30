// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {TestOracleSource} from "../helper/TestOracleSource.sol";

import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {LicenseAccountFactoryBeacon} from "../../src/licenseAccount/LicenseAccountFactoryBeacon.sol";
import {DimoDeveloperLicenseAccountBeacon} from "../../src/licenseAccount/DimoDeveloperLicenseAccountBeacon.sol";

//forge test --match-path ./test/LicenseAccount.t.sol -vv
contract LicenseAccountTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    bytes32 constant LICENSE_ALIAS_1 = "licenseAlias1";
    bytes32 constant LICENSE_ALIAS_2 = "licenseAlias2";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    IDimoToken dimoToken;
    DimoCredit dimoCredit;
    DevLicenseDimo devLicense;
    address factory;

    address _admin;
    address _receiver;

    function setUp() public {
        uint256 licenseCostInUsd1e18 = 100 ether;
        _admin = address(0x1);
        _receiver = address(0x888);

        vm.createSelectFork("https://polygon-rpc.com", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        TestOracleSource testOracleSource = new TestOracleSource();
        uint256 amountUsdPerToken = 1 ether;
        testOracleSource.setAmountUsdPerToken(amountUsdPerToken);

        NormalizedPriceProvider provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        provider.addOracleSource(address(testOracleSource));

        factory = _deployLicenseAccountFactory(_admin);

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
                    factory,
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

        devLicense = DevLicenseDimo(proxyDl);

        LicenseAccountFactoryBeacon(factory).setDevLicenseDimo(address(devLicense));
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

    function test_initTemplateNotEffectClone() public {
        address beaconProxyTemplate = LicenseAccountFactoryBeacon(factory).beaconProxyTemplate();
        DimoDeveloperLicenseAccountBeacon(beaconProxyTemplate).initialize(1, address(0x999));

        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(devLicense), 1_000_000 ether);

        (uint256 tokenId00, address clientId00) = devLicense.issueInDimo(LICENSE_ALIAS_1);
        //console2.log("tokenId00: %s", tokenId00);
        assertEq(tokenId00, 1);

        vm.expectRevert("DimoDeveloperLicenseAccount: invalid operation");
        DimoDeveloperLicenseAccountBeacon(clientId00).initialize(tokenId00, address(devLicense));

        (uint256 tokenId01,) = devLicense.issueInDimo(LICENSE_ALIAS_2);
        //console2.log("tokenId01: %s", tokenId01);
        assertEq(tokenId01, 2);
    }

    /**
     */
    function test_ReInitFail() public {
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(devLicense), 1_000_000 ether);

        (uint256 tokenId, address clientId) = devLicense.issueInDimo(LICENSE_ALIAS_1);

        vm.expectRevert("DimoDeveloperLicenseAccountBeacon: invalid operation");
        DimoDeveloperLicenseAccountBeacon(clientId).initialize(tokenId, address(devLicense));
    }

    function test_redirectUri() public {
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(devLicense), 1_000_000 ether);

        (uint256 tokenId,) = devLicense.issueInDimo(LICENSE_ALIAS_1);

        string memory uri = "https://www.dimo.zone";

        devLicense.setRedirectUri(tokenId, true, uri);

        bool status = devLicense.redirectUriStatus(tokenId, uri);
        assertEq(status, true);

        devLicense.setRedirectUri(tokenId, false, uri);

        status = devLicense.redirectUriStatus(tokenId, uri);
        assertEq(status, false);
    }

    function test_redirectUriEvent() public {
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(devLicense), 1_000_000 ether);

        (uint256 tokenId,) = devLicense.issueInDimo(LICENSE_ALIAS_1);

        string memory uri = "https://www.dimo.zone";

        vm.expectEmit();
        emit DevLicenseDimo.RedirectUriEnabled(tokenId, uri);

        devLicense.setRedirectUri(tokenId, true, uri);

        vm.expectEmit();
        emit DevLicenseDimo.RedirectUriDisabled(tokenId, uri);

        devLicense.setRedirectUri(tokenId, false, uri);
    }
}
