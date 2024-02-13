// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DevLicenseDimo} from "../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {TwapV3} from "../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";
import {DimoCredit} from "../src/DimoCredit.sol";
import {IDimoToken} from "../src/interface/IDimoToken.sol";

//forge test --match-path ./test/DevLicenseLock.t.sol -vv
contract DevLicenseLockTest is Test {

    ERC20 dimoToken;
    DevLicenseDimo license;

    DimoCredit dc;
    NormalizedPriceProvider npp;

    uint256 tokenId;
    address clientId;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        dimoToken = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        LicenseAccountFactory laf = new LicenseAccountFactory();

        npp = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);
        npp.addOracleSource(address(twap));

        dc = new DimoCredit("NAME", "SYMBOL", 18, address(0x123), address(npp));

        license = new DevLicenseDimo(
            address(laf), 
            address(npp), 
            address(dimoToken), 
            address(dc),
            100
        );

        laf.setLicense(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);

        (tokenId, clientId) = license.issueInDimo();    
    }

    function test_lockSuccess() public { 

        address user00 = address(this);
        license.enableSigner(tokenId, user00);

        uint256 amount00 = 1 ether;
        license.lock(tokenId, amount00); 

        assertEq(license.balanceOf(tokenId), amount00);
        //assertEq(license.balanceOfLockUpLicense(tokenId), amount00);

        address user01 = address(0x123);
        uint256 amount01 = 1_000_000 ether;
        license.enableSigner(tokenId, user01);
        deal(address(dimoToken), user01, amount01);

        vm.startPrank(user01);
        dimoToken.approve(address(license), amount01);
        license.lock(tokenId, amount01); 
        vm.stopPrank();
        
        assertEq(license.balanceOf(tokenId), amount00 + amount01);
        //assertEq(license.balanceOfLockUpLicense(tokenId), amount00 + amount01);
        assertEq(dimoToken.balanceOf(address(license)), amount00 + amount01);
    }

    //_dimoToken.approve(address spender, uint256 amount)
    function test_reallocateSuccess() public { 

        vm.startPrank(0xCED3c922200559128930180d3f0bfFd4d9f4F123);
        IDimoToken(address(dimoToken)).grantRole(keccak256("BURNER_ROLE"), address(license));
        vm.stopPrank();

        address user00 = address(this);
        license.enableSigner(tokenId, user00);

        uint256 amount00 = 1 ether;
        license.lock(tokenId, amount00); 

        assertEq(license.balanceOf(tokenId), amount00);
        //assertEq(license.balanceOfLockUpLicense(tokenId), amount00);
        assertEq(dimoToken.balanceOf(address(license)), amount00);

        address user01 = address(0x123);
        
        license.burn(tokenId, amount00);
        //TODO: accounting is a problem here...
        
        //assertEq(license.balanceOfLockUpUser(tokenId, user01), 0);
        //assertEq(license.balanceOfLockUpLicense(tokenId), 0);
        assertEq(dimoToken.balanceOf(address(license)), 0);
    }

    
}
