// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {IERC721} from "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import {IERC5192} from "../src/interface/IERC5192.sol";
import {IERC721Metadata} from "openzeppelin-contracts/contracts/interfaces/IERC721Metadata.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {TwapV3} from "../src/provider/TwapV3.sol";

import {DimoCredit} from "../src/DimoCredit.sol";
import {IDimoCredit} from "../src/interface/IDimoCredit.sol";
import {DevLicenseDimo} from "../src/DevLicenseDimo.sol";
import {IDimoToken} from "../src/interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/RevokeBurn.t.sol -vv
contract RevokeBurnTest is Test {

    IDimoToken dimoToken;
    IDimoCredit dimoCredit;

    DevLicenseDimo license;
    NormalizedPriceProvider provider;

    address _dimoAdmin;

    function setUp() public {
        _dimoAdmin = address(0x666);

        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        provider = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        LicenseAccountFactory laf = new LicenseAccountFactory();

        vm.startPrank(_dimoAdmin);
        dimoCredit = IDimoCredit(address(new DimoCredit("NAME", "SYMBOL", 18, address(0x123), address(provider))));
        license = new DevLicenseDimo(
            address(laf), 
            address(provider), 
            address(dimoToken), 
            address(dimoCredit),
            100
        );
        vm.stopPrank();

        laf.setLicense(address(license));
    }
    
    function test_burnSuccess() public {

        address user = address(0x2024);
        deal(address(dimoToken), user, 10_000 ether);
        

        vm.startPrank(user);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId,) = license.issueInDimo();
        vm.expectRevert(
            abi.encodeWithSelector(IAccessControl.AccessControlUnauthorizedAccount.selector, 
            user, 
            license.BURNER_ROLE())
        );
        license.burn(tokenId);
        vm.stopPrank();

        vm.startPrank(_dimoAdmin);
        license.grantRole(keccak256("BURNER_ROLE"), _dimoAdmin);
        license.burn(tokenId);
        vm.stopPrank();
    }
    
}
