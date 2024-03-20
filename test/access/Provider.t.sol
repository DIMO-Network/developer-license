// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";

import {TwapV3} from "../../src/provider/TwapV3.sol";

import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";

//forge test --match-path ./test/access/Provider.t.sol -vv
contract ProviderTest is Test {

    TwapV3 twap;
    NormalizedPriceProvider provider;

    function setUp() public {
        //vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        vm.createSelectFork('https://polygon-mainnet.infura.io/v3/89d890fd291a4096a41aea9b3122eb28', 50573735);

        twap = new TwapV3();
        provider = new NormalizedPriceProvider();
    }
    
    function test_unitTestAccess() public {

        address adminOracle = address(0x666);
        
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), adminOracle); 

        vm.startPrank(adminOracle);
        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes; 
        twap.initialize(intervalUsdc, intervalDimo);
        vm.stopPrank();

        address adminProvider = address(0x777);

        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), adminProvider); 
        
        vm.startPrank(adminProvider);
        provider.addOracleSource(address(twap));
        vm.stopPrank();

        address updater = address(0x888);

        provider.grantRole(keccak256("UPDATER_ROLE"), updater); 

        vm.startPrank(updater);
        provider.updatePrice();
        vm.stopPrank();
        
    }
   
}
