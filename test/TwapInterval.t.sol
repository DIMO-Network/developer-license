// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {TwapV3} from "../src/provider/TwapV3.sol";

//forge test --match-path ./test/TwapInterval.t.sol -vv
contract TwapIntervalTest is Test {

    TwapV3 twap;

    function setUp() public {
        //vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        uint256 marchTwnetyFourPmEst = 54889372;
        vm.createSelectFork(
            'https://polygon-mainnet.infura.io/v3/89d890fd291a4096a41aea9b3122eb28', 
            marchTwnetyFourPmEst
        );

        // 1 USDC ~ 1.00428 MATIC
        // 1 DIMO ~ 0.44209 MATIC

        /* * */

        // 1 MATIC ~ 0.9943 USDC
        // 1 DIMO ~ 0.43966 USDC
        

        twap = new TwapV3();
    }
    
    function test_getAmountUsdPerToken() public {


        (uint256 amountUsdPerToken, uint256 updateTimestamp) = twap.getAmountUsdPerToken();
        //439746722760396201


        //twap = new TwapV3();
        //0.439746722760396201

        uint32 twapIntervalUsdc = twap.getIntervalUsdc();
        assertEq(1 minutes, twapIntervalUsdc);

        uint32 twapIntervalDimo = twap.getIntervalDimo();
        assertEq(1 minutes, twapIntervalDimo);

        assertEq(0.439746722760396201 ether, amountUsdPerToken);

        console2.log("amountUsdPerToken: %s", amountUsdPerToken); 
    }
   
}
