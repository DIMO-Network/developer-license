// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {ForkProvider} from "../helper/ForkProvider.sol";
import {TestOracleSource} from "../helper/TestOracleSource.sol";

import {DimoCredit} from "../../src/DimoCredit.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";

import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {DimoDeveloperLicenseAccount} from "../../src/licenseAccount/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../../src/licenseAccount/LicenseAccountFactory.sol";

//forge test --match-path ./test/staking/IntegrationStake.t.sol -vv
contract IntegrationStakeTest is Test, ForkProvider {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    bytes32 constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    NormalizedPriceProvider provider;

    IDimoToken dimoToken;
    IDimoCredit dimoCredit;

    DevLicenseDimo license;

    address _dimoAdmin;
    address _receiver;

    function setUp() public {
        _dimoAdmin = address(0x666);
        _receiver = address(0x888);

        ForkProvider fork = new ForkProvider();
        vm.createSelectFork(fork._url(), 50573735);

        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        TestOracleSource testOracleSource = new TestOracleSource();
        testOracleSource.setAmountUsdPerToken(1 ether);
        provider.addOracleSource(address(testOracleSource));

        LicenseAccountFactory laf = _deployLicenseAccountFactory(_dimoAdmin);

        vm.startPrank(_dimoAdmin);
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

        dimoCredit = IDimoCredit(proxyDc);

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
                    1 ether,
                    IMAGE_SVG,
                    METADATA_DESCRIPTION
                )
            ),
            opts
        );

        license = DevLicenseDimo(proxyDl);
        vm.stopPrank();

        laf.grantRole(keccak256("ADMIN_ROLE"), _dimoAdmin);

        vm.startPrank(_dimoAdmin);
        laf.setDevLicenseDimo(address(license));
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

    function test_fuzzStake(uint256 amount) public {
        amount = bound(amount, 1.1 ether, type(uint256).max);

        address user = address(0x1337);

        deal(address(dimoToken), user, amount);

        uint256 balanceOf00 = ERC20(address(dimoToken)).balanceOf(user);
        assertEq(balanceOf00, amount);

        vm.startPrank(user);
        dimoToken.approve(address(license), 1 ether);
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();

        uint256 balanceOf01 = ERC20(address(dimoToken)).balanceOf(user);
        assertEq(balanceOf01, amount - 1 ether);

        vm.startPrank(user);
        dimoToken.approve(address(license), amount - 1 ether);
        license.lock(tokenId, amount - 1 ether);
        vm.stopPrank();

        assertEq(license.stakedBalance(tokenId), amount - 1 ether);

        vm.startPrank(_dimoAdmin);
        license.grantRole(license.LICENSE_ADMIN_ROLE(), _dimoAdmin);
        bool frozen = true;
        license.adminFreeze(tokenId, frozen);
        vm.stopPrank();

        vm.startPrank(user);
        uint256 amountWithdraw = license.stakedBalance(tokenId);
        vm.expectRevert("DevLicenseDimo: funds inaccessible");
        license.withdraw(tokenId, amountWithdraw);
        vm.stopPrank();
    }
}
