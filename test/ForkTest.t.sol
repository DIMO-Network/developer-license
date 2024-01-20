// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

//forge test --match-path ./test/ForkTest.t.sol -vv
contract ForkTest is Test {

    function setUp() public {

        //0xE261D618a959aFfFd53168Cd07D12E37B26761db
        //^DIMO Token Polygon
        
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
    }

    /**
     * 
     */
    function test_001() public {

        deal(0xE261D618a959aFfFd53168Cd07D12E37B26761db, address(this), 1 ether);

        uint256 balance = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db).balanceOf(address(this));
        assertEq(balance, 1 ether);
    
    }

}