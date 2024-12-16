// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {TwapV3} from "../../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

//forge test --match-path ./test/credits/Misc.t.sol -vv
contract MiscDimoCreditTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;

    DimoCredit dc;
    IDimoToken dimoToken;
    NormalizedPriceProvider npp;

    address _receiver;

    function setUp() public {
        _receiver = address(0x123);

        vm.createSelectFork(vm.rpcUrl("https://polygon-rpc.com"));
        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        TwapV3 twap = new TwapV3();
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this));

        uint32 intervalUsdc = 30 minutes;
        uint32 intervalDimo = 4 minutes;
        twap.initialize(intervalUsdc, intervalDimo);

        npp = new NormalizedPriceProvider();
        npp.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        npp.addOracleSource(address(twap));

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxyDc = Upgrades.deployUUPSProxy(
            "DimoCredit.sol",
            abi.encodeCall(
                DimoCredit.initialize,
                (DC_NAME, DC_SYMBOL, address(dimoToken), _receiver, address(npp), DC_VALIDATION_PERIOD, DC_RATE)
            ),
            opts
        );

        dc = DimoCredit(proxyDc);
    }

    function test_getQuote() public {
        address sender = address(0x1337);
        address user = address(0x13399);
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), sender, amountIn);

        // Perform a mint to update the price
        vm.startPrank(sender);
        dimoToken.approve(address(dc), amountIn);
        uint256 amountDc = dc.mintInDimo(user, amountIn);
        vm.stopPrank();

        // Check if the latest updated price matches the getQuote
        assertEq(dc.getQuote(), amountDc);
    }

    function test_getQuoteWithValue() public {
        address sender = address(0x1337);
        address user = address(0x13399);
        uint256 amountIn = 10 ether;

        deal(address(dimoToken), sender, amountIn);

        // Perform a mint to update the price
        vm.startPrank(sender);
        dimoToken.approve(address(dc), amountIn);
        uint256 amountDc = dc.mintInDimo(user, amountIn);
        vm.stopPrank();

        // Check if the latest updated price matches the getQuote
        assertEq(dc.getQuote(amountIn), amountDc);
    }

    function test_getQuoteDc() public {
        address sender = address(0x1337);
        address user = address(0x13399);
        uint256 amountOut = 1 ether;
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), sender, amountIn);

        vm.startPrank(sender);
        dimoToken.approve(address(dc), amountIn);
        dc.mint(user, amountOut);
        vm.stopPrank();

        uint256 senderDimoSpent = amountIn - dimoToken.balanceOf(sender);

        // Check if the latest updated price matches the getQuote
        assertEq(dc.getQuoteDc(amountOut), senderDimoSpent);
    }

    function test_getQuoteDcWithValue() public {
        address sender = address(0x1337);
        address user = address(0x13399);
        uint256 amountOut = 10 ether;
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), sender, amountIn);

        vm.startPrank(sender);
        dimoToken.approve(address(dc), amountIn);
        dc.mint(user, amountOut);
        vm.stopPrank();

        uint256 senderDimoSpent = amountIn - dimoToken.balanceOf(sender);

        // Check if the latest updated price matches the getQuote
        assertEq(dc.getQuoteDc(amountOut), senderDimoSpent);
    }
}
