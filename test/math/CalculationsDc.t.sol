// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
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

        //vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        vm.createSelectFork("https://polygon-mainnet.infura.io/v3/89d890fd291a4096a41aea9b3122eb28", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        testOracleSource = new TestOracleSource();
        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        provider.addOracleSource(address(testOracleSource));

        LicenseAccountFactory factory = new LicenseAccountFactory();

        dimoCredit = new DimoCredit(_receiver, address(provider));

        licenseCostInUsd = 0;
        // devLicense = new DevLicenseDimo(
        //     address(0x888),
        //     address(factory),
        //     address(provider),
        //     address(dimoToken),
        //     address(dimoCredit),
        //     licenseCostInUsd
        // );

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
                    licenseCostInUsd
                )
            )
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
