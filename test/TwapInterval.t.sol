// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {TwapV3} from "../src/provider/TwapV3.sol";

//forge test --match-path ./test/TwapInterval.t.sol -vv
contract TwapIntervalTest is Test {

//Because spot prices are easy and relatively cheap to manipulate, most protocols use a rolling 30-minute time window for TWAP to calculate the price3. Using TWAP with a long window causes prices to be smooth but lagging.
//Since most protocols use a 30 minute running TWAP, waiting more blocks allows more of the total weighting on the final manipulated price.

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

        uint32 twapIntervalUsdc = 1 minutes;
        uint32 twapIntervalDimo = 1 minutes;
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this)); 
        twap.setTwapIntervalUsdc(twapIntervalUsdc);
        twap.setTwapIntervalDimo(twapIntervalDimo);

        (uint256 amountUsdPerToken, uint256 updateTimestamp) = twap.getAmountUsdPerToken();
        //console2.log("amountUsdPerToken: %s", amountUsdPerToken); 
        console2.log("updateTimestamp: %s", updateTimestamp); 
        //439746722760396201

        //twap = new TwapV3();
        //0.439746722760396201

        uint32 twapIntervalUsdc00 = twap.getIntervalUsdc();
        assertEq(1 minutes, twapIntervalUsdc00);

        uint32 twapIntervalDimo00 = twap.getIntervalDimo();
        assertEq(1 minutes, twapIntervalDimo00);

        assertEq(0.439746722760396201 ether, amountUsdPerToken);
    }

    function test_30minutes() public {


        (uint256 amountUsdPerToken,) = twap.getAmountUsdPerToken();
        console2.log("amountUsdPerToken: %s", amountUsdPerToken); 
        // 437503402621950580
        // 0.43750340262195058

        uint32 twapIntervalUsdc = twap.getIntervalUsdc();
        assertEq(30 minutes, twapIntervalUsdc);

        uint32 twapIntervalDimo = twap.getIntervalDimo();
        assertEq(30 minutes, twapIntervalDimo);

        assertEq(0.43750340262195058 ether, amountUsdPerToken);
    }
   
}
