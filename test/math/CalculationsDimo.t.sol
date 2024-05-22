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

//forge test --match-path ./test/math/CalculationsDimo.t.sol -vv
contract CalculationsDimoTest is Test {
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
        license = DevLicenseDimo(proxy);

        factory.setLicense(address(license));
    }

    function test_1to1simpleCase() public {
        address invoker = vm.addr(0x666);

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), _admin);

        uint256 amountUsdPerToken = 1 ether;
        testOracleSource.setAmountUsdPerToken(amountUsdPerToken);

        uint256 licenseCostUpdate = 1 ether;

        vm.startPrank(_admin);
        license.setLicenseCost(licenseCostUpdate);
        vm.stopPrank();

        deal(address(dimoToken), invoker, 1 ether);

        ///@dev before
        uint256 balanceOf00a = dimoToken.balanceOf(invoker);
        assertEq(balanceOf00a, 1 ether);
        uint256 balanceOf00b = dimoToken.balanceOf(_receiver);
        assertEq(balanceOf00b, 0);

        vm.startPrank(invoker);
        dimoToken.approve(address(license), 1 ether);
        license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();

        ///@dev after
        uint256 balanceOf01a = dimoToken.balanceOf(invoker);
        assertEq(balanceOf01a, 0);
        uint256 balanceOf01b = dimoToken.balanceOf(_receiver);
        assertEq(balanceOf01b, 1 ether);
    }

    function test_calculate() public {
        address invoker = vm.addr(0x666);

        license.grantRole(keccak256("LICENSE_ADMIN_ROLE"), _admin);

        uint256 amountUsdPerToken = 0.25 ether; //250000000000000000
        testOracleSource.setAmountUsdPerToken(amountUsdPerToken);

        uint256 licenseCostUpdate = 2 ether;

        vm.startPrank(_admin);
        license.setLicenseCost(licenseCostUpdate);
        vm.stopPrank();

        deal(address(dimoToken), invoker, 8 ether);

        ///@dev before
        uint256 balanceOf00a = dimoToken.balanceOf(invoker);
        assertEq(balanceOf00a, 8 ether);
        uint256 balanceOf00b = dimoToken.balanceOf(_receiver);
        assertEq(balanceOf00b, 0);

        vm.startPrank(invoker);
        dimoToken.approve(address(license), 8 ether);
        license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();

        ///@dev after
        uint256 balanceOf01a = dimoToken.balanceOf(invoker);
        assertEq(balanceOf01a, 0);
        uint256 balanceOf01b = dimoToken.balanceOf(_receiver);
        assertEq(balanceOf01b, 8 ether);
    }
}
