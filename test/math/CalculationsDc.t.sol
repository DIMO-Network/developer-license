// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {TestOracleSource} from "../helper/TestOracleSource.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {LicenseAccountFactory} from "../../src/LicenseAccountFactory.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/CalculationsDc.t.sol -vv
contract CalculationsDcTest is Test {
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

        LicenseAccountFactory factory = new LicenseAccountFactory();

        dimoCredit = new DimoCredit(_receiver, address(provider));

        licenseCostInUsd = 0;

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxy = Upgrades.deployUUPSProxy(
            "DevLicenseDimo.sol",
            abi.encodeCall(
                DevLicenseDimo.initialize,
                (
                    address(0x888),
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

        license = DevLicenseDimo(proxy);

        factory.setLicense(address(license));
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
        vm.stopPrank();

        dimoCredit.mint(to, amountIn, "");

        dimoCredit.grantRole(keccak256("BURNER_ROLE"), address(license));

        vm.startPrank(to);
        (uint256 tokenId,) = license.issueInDc(LICENSE_ALIAS);
        vm.stopPrank();

        assertEq(tokenId, 1);
    }
}
