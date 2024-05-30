// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC721} from "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {IERC721Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {DimoDeveloperLicenseAccountBeacon} from "../../src/licenseAccount/DimoDeveloperLicenseAccountBeacon.sol";
import {LicenseAccountFactoryBeacon} from "../../src/licenseAccount/LicenseAccountFactoryBeacon.sol";
import {TwapV3} from "../../src/provider/TwapV3.sol";

import {IERC5192} from "../../src/interface/IERC5192.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/staking/RevokeBurnReallocate.t.sol -vv
contract RevokeBurnReallocateTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;
    bytes32 constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    IDimoToken dimoToken;
    IDimoCredit dimoCredit;

    DevLicenseDimo license;
    NormalizedPriceProvider provider;

    address _admin;
    address _receiver;
    address _user1;
    address _user2;

    function setUp() public {
        _admin = address(0x1);
        _receiver = address(0x2);
        _user1 = address(0x888);
        _user2 = address(0x999);

        vm.createSelectFork("https://polygon-rpc.com", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));

        TwapV3 twap = new TwapV3();
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this));
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes;
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        address laf = _deployLicenseAccountFactory(_admin);

        vm.startPrank(_admin);
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
                    laf,
                    address(provider),
                    address(dimoToken),
                    address(dimoCredit),
                    100,
                    IMAGE_SVG,
                    METADATA_DESCRIPTION
                )
            ),
            opts
        );

        license = DevLicenseDimo(proxyDl);
        vm.stopPrank();

        LicenseAccountFactoryBeacon(laf).setDevLicenseDimo(address(license));
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

    /**
     * revoke/burn a license
     */
    function test_burnSuccess() public {
        deal(address(dimoToken), _user1, 10_000 ether);

        vm.startPrank(_user1);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector, _user1, license.REVOKER_ROLE()
            )
        );
        license.revoke(tokenId);
        vm.stopPrank();

        address owner = license.ownerOf(tokenId);
        assertEq(owner, _user1);
        // console2.log(license.ownerOf(tokenId));

        vm.startPrank(_admin);
        license.grantRole(keccak256("REVOKER_ROLE"), _admin);
        license.revoke(tokenId);
        vm.stopPrank();

        // vm.expectRevert("DevLicenseDimo: invalid tokenId");
        vm.expectRevert();
        license.ownerOf(tokenId);
    }

    function test_burnSuccess_deleteLicenseAlias() public {
        deal(address(dimoToken), _user1, 10_000 ether);

        vm.startPrank(_user1);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector, _user1, license.REVOKER_ROLE()
            )
        );
        license.revoke(tokenId);
        vm.stopPrank();

        address owner = license.ownerOf(tokenId);
        assertEq(owner, _user1);

        bytes32 aliasBefore = license.getLicenseAliasByTokenId(1);
        uint256 tokenIdBefore = license.getTokenIdByLicenseAlias(LICENSE_ALIAS);
        assertEq(aliasBefore, LICENSE_ALIAS);
        assertEq(tokenIdBefore, 1);

        vm.startPrank(_admin);
        license.grantRole(keccak256("REVOKER_ROLE"), _admin);
        license.revoke(tokenId);
        vm.stopPrank();

        bytes32 aliasAfter = license.getLicenseAliasByTokenId(1);
        uint256 tokenIdAfter = license.getTokenIdByLicenseAlias(LICENSE_ALIAS);
        assertEq(aliasAfter, "");
        assertEq(tokenIdAfter, 0);
    }

    /**
     * reallocate someone's staked tokens
     */
    function test_reallocate() public {
        deal(address(dimoToken), _user1, 10_000 ether);

        vm.startPrank(_user1);
        dimoToken.approve(address(license), 10_000 ether);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);
        vm.stopPrank();

        uint256 amount99 = 1 ether;

        vm.startPrank(_user1);
        license.lock(tokenId, amount99);
        vm.stopPrank();

        uint256 amount00 = license.stakedBalances(tokenId);
        uint256 amount01 = dimoToken.balanceOf(address(license));
        assertEq(amount00, amount01);

        bytes32 role = license.LICENSE_ADMIN_ROLE();
        vm.startPrank(_admin);
        license.grantRole(role, _admin);
        vm.stopPrank();

        vm.startPrank(_admin);
        license.adminReallocate(tokenId, amount00, _user2);
        vm.stopPrank();

        uint256 amount02 = license.stakedBalances(tokenId);
        assertEq(amount02, 0);

        uint256 amount0x = dimoToken.balanceOf(_user2);
        assertEq(amount0x, amount00);
    }

    // function test_burnFailLock() public {

    // }
}
