// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC721} from "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC721Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {LicenseAccountFactory} from "../../src/LicenseAccountFactory.sol";
import {TwapV3} from "../../src/provider/TwapV3.sol";

import {IERC5192} from "../../src/interface/IERC5192.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/staking/RevokeBurnReallocate.t.sol -vv
contract RevokeBurnReallocateTest is Test {
    bytes32 constant LICENSE_ALIAS = "licenseAlias";

    IDimoToken dimoToken;
    IDimoCredit dimoCredit;

    DevLicenseDimo license;
    NormalizedPriceProvider provider;

    address _admin;
    address _user1;
    address _user2;

    function setUp() public {
        _admin = address(0x1);
        _user1 = address(0x888);
        _user2 = address(0x999);

        //vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        vm.createSelectFork("https://polygon-mainnet.infura.io/v3/89d890fd291a4096a41aea9b3122eb28", 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));

        TwapV3 twap = new TwapV3();
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this));
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes;
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        LicenseAccountFactory laf = new LicenseAccountFactory();

        vm.startPrank(_admin);
        dimoCredit = IDimoCredit(address(new DimoCredit(address(0x123), address(provider))));

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxy = Upgrades.deployUUPSProxy(
            "DevLicenseDimo.sol",
            abi.encodeCall(
                DevLicenseDimo.initialize,
                (address(0x888), address(laf), address(provider), address(dimoToken), address(dimoCredit), 100)
            ),
            opts
        );
        license = DevLicenseDimo(proxy);
        vm.stopPrank();

        laf.setLicense(address(license));
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

        uint256 amount00 = license.licenseStaked(tokenId);
        uint256 amount01 = dimoToken.balanceOf(address(license));
        assertEq(amount00, amount01);

        bytes32 role = license.LICENSE_ADMIN_ROLE();
        vm.startPrank(_admin);
        license.grantRole(role, _admin);
        vm.stopPrank();

        vm.startPrank(_admin);
        license.adminReallocate(tokenId, amount00, _user2);
        vm.stopPrank();

        uint256 amount02 = license.licenseStaked(tokenId);
        assertEq(amount02, 0);

        uint256 amount0x = dimoToken.balanceOf(_user2);
        assertEq(amount0x, amount00);
    }

    // function test_burnFailLock() public {

    // }
}
