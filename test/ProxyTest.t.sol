// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {Proxy} from "../src/test/Proxy.sol";
import {Dimo} from "../src/test/DimoV2.sol";
import {DimoChildTokenV1} from "../src/test/DimoChildTokenV1.sol";

//forge test --match-path ./test/ProxyTest.t.sol -vv
contract ProxyTest is Test {

    DimoChildTokenV1 public dct1;
    DimoChildTokenV1 public proxiedDct1;
    Dimo public dimo;
    Dimo public proxiedDimo;

    address public user;
    uint256 public amount;

    function setUp() public {

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

        // (5) Upgrade to a new logic contract
        proxy.upgradeTo(address(dimo));
        proxiedDimo = Dimo(address(proxiedDct1));

        // (6) Now calling this function should actually work
        proxiedDimo.grantRole(keccak256("MINTER_ROLE"), address(this));
    }

    /**
     *   
     */
    function test_001() public {

        proxiedDimo.mint(user, amount);

        uint256 balance00 = proxiedDimo.balanceOf(user);
        assertEq(balance00, amount);

        
    }

}