// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {Proxy} from "../src/test/Proxy.sol";
import {Dimo} from "../src/test/DimoV2.sol";

//forge test --match-path ./test/ProxyTest.t.sol -vv
contract ProxyTest is Test {

    DimoV1 public dct1;
    DimoV1 public proxiedDct1;
    DimoV2 public dimo;
    DimoV2 public proxiedDimo;

    TwapV3 public twapV3;
    DimoDataCredit public dimoDataCredit;
    NormalizedPriceProvider public provider;
    DimoMarketRewards public marketRewards;

    address public user;
    uint256 public amount;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        user = address(0x1337);
        amount = 1 ether;   

        dimo = new Dimo();        
    
        // (1) Create logic contract
        dct1 = new DimoChildTokenV1();

        // (2) Create proxy and tell it which logic contract to use
        Proxy proxy = new Proxy();
        proxy.upgradeTo(address(dct1));

        // (3) To be able to call functions from the logic contract, we need to
        //     cast the proxy to the right type
        proxiedDct1 = DimoChildTokenV1(address(proxy));
        proxiedDct1.initialize();

        // (4) Now we treat the proxy as if it were the logic contract
        bytes32 defaultAdminRole = 0x00;
        address account = address(this);
        bool hasRole = proxiedDct1.hasRole(defaultAdminRole, account);
        assertEq(hasRole, true);

        // (5) Upgrade to a new logic contract
        proxy.upgradeTo(address(dimo));
        proxiedDimo = Dimo(address(proxiedDct1));

        // (6) Now calling this function should actually works
        proxiedDimo.grantRole(keccak256("MINTER_ROLE"), address(this));
    }

    /**
     *   [17972] ForkTest::test_001() 
     *   ├─ [0] console::log(***) [staticcall]
     *   │   └─ ← ()
     *   ├─ [9082] 0x41e64a5Bc929fA8E6a9C8d7E3b81A13b21Ff3045::observe([300, 0]) [staticcall]
     *   │   └─ ← "OLD"
     *   └─ ← "OLD"
     *   
     */
    function test_001() public {

        address to = user;
        uint256 amountIn = amount;
        bytes memory data = "";
        proxiedDimo.mint(to, amountIn);

        uint256 balance00 = proxiedDimo.balanceOf(to);
        assertEq(balance00, amountIn);

        uint32 twapIntervalUsdc = 1 minutes;
        console2.log("twapIntervalUsdc: %s", twapIntervalUsdc);
        uint32 twapIntervalDimo = 1 minutes; 
        console2.log("twapIntervalDimo: %s", twapIntervalDimo);

        twapV3 = new TwapV3();
        twapV3.initialize(twapIntervalUsdc, twapIntervalDimo);
        marketRewards = new DimoMarketRewards();
        provider = new NormalizedPriceProvider();
        provider.addOracleSource(address(twapV3));
        dimoDataCredit = new DimoDataCredit();
        dimoDataCredit.initialize(
            address(proxiedDimo), 
            address(0x123), 
            address(provider), 
            1 days
        );

        vm.startPrank(to);
        proxiedDimo.approve(address(dimoDataCredit), amountIn);
        vm.stopPrank();

        uint256 allowance = proxiedDimo.allowance(to, address(dimoDataCredit));
        assertEq(allowance, amountIn);

        dimoDataCredit.mint(to, amountIn, data);

        uint256 balance01 = proxiedDimo.balanceOf(to);
        assertEq(balance01, 0);

        uint256 balance02 = dimoDataCredit.balanceOf(to);
        console2.log("balance02: %s", balance02);
    }

}