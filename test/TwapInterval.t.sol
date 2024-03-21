// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {IUniswapV3Pool} from "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import {TwapV3} from "../src/provider/TwapV3.sol";

//forge test --match-path ./test/TwapInterval.t.sol -vv
contract TwapIntervalTest is Test {

    /**
     * @dev Because spot prices are easy and relatively cheap to manipulate, most protocols use a 
     * rolling 30-minute time window for TWAP to calculate the price3. Using TWAP with a long window 
     * causes prices to be smooth but lagging.
     * 
     * Since most protocols use a 30 minute running TWAP, waiting more blocks allows more of the total 
     * weighting on the final manipulated price.
     * 
     * https://blog.uniswap.org/uniswap-v3-oracles
     */
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
    
    // function test_getAmountUsdPerToken() public {
    //     uint32 twapIntervalUsdc = 1 minutes;
    //     uint32 twapIntervalDimo = 1 minutes;
    //     twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this)); 
    //     twap.setTwapIntervalUsdc(twapIntervalUsdc);
    //     twap.setTwapIntervalDimo(twapIntervalDimo);

    //     (uint256 amountUsdPerToken, uint256 updateTimestamp) = twap.getAmountUsdPerToken();
    //     //console2.log("amountUsdPerToken: %s", amountUsdPerToken); 
    //     console2.log("updateTimestamp: %s", updateTimestamp); 
    //     //439746722760396201
    //     //0.439746722760396201

    //     uint32 twapIntervalUsdc00 = twap.getIntervalUsdc();
    //     assertEq(1 minutes, twapIntervalUsdc00);

    //     uint32 twapIntervalDimo00 = twap.getIntervalDimo();
    //     assertEq(1 minutes, twapIntervalDimo00);

    //     assertEq(0.439746722760396201 ether, amountUsdPerToken);
    // }

    // function test_30minutes() public {
    //     (uint256 amountUsdPerToken,) = twap.getAmountUsdPerToken();
    //     console2.log("amountUsdPerToken: %s", amountUsdPerToken); 
    //     // 437503402621950580
    //     // 0.43750340262195058

    //     uint32 twapIntervalUsdc = twap.getIntervalUsdc();
    //     assertEq(30 minutes, twapIntervalUsdc);

    //     uint32 twapIntervalDimo = twap.getIntervalDimo();
    //     assertEq(30 minutes, twapIntervalDimo);

    //     assertEq(0.43750340262195058 ether, amountUsdPerToken);
    // }


    ///  notice Swap token0 for token1, or token1 for token0
    ///  dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
    ///  param recipient The address to receive the output of the swap
    ///  param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
    ///  param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
    ///  param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
    /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
    ///  param data Any data to be passed through to the callback
    ///  return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
    ///  return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
    // function swap(
    //     address recipient,
    //     bool zeroForOne,
    //     int256 amountSpecified,
    //     uint160 sqrtPriceLimitX96,
    //     bytes calldata data
    // ) external returns (int256 amount0, int256 amount1);
    function test_attack() public {
        (uint256 amountUsdPerToken00,) = twap.getAmountUsdPerToken();
        console2.log("amountUsdPerToken00: %s", amountUsdPerToken00); 

        // The address to receive the output of the swap
        address recipient = address(0x123);
        // The direction of the swap, true for token0 to token1, false for token1 to token0
        bool zeroForOne = true;
        // The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
        int256 amountSpecified = 1 ether;
        // The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
        // value after the swap. If one for zero, the price cannot be greater than this value after the swap
        uint160 sqrtPriceLimitX96 = 0;
        bytes memory data = "";

        deal(address(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270), address(this), 1_000_000 ether);

        IUniswapV3Pool(twap.poolWmaticDimo()).swap(
            recipient,
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            data
        );

        //IUniswapV3Pool(twap.poolWmaticDimo()).swap0ForExact1();
        

        
    }

    // function swapExact0For1(
    //     address pool,
    //     uint256 amount0In,
    //     address recipient,
    //     uint160 sqrtPriceLimitX96
    // ) external {
    //     IUniswapV3Pool(pool).swap(recipient, true, amount0In.toInt256(), sqrtPriceLimitX96, abi.encode(msg.sender));
    // }
   
}
