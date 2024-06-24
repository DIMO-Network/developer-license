// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";

import {ForkProvider} from "../helper/ForkProvider.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {TestOracleSource} from "../helper/TestOracleSource.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";

//forge test --match-path ./test/credits/DcCalc.t.sol -vv
contract DcCalcTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;

    DimoCredit dc;
    IDimoToken dimoToken;

    address _receiver;
    TestOracleSource oracle;
    NormalizedPriceProvider provider;

    function setUp() public {
        ForkProvider fork = new ForkProvider();
        vm.createSelectFork(fork._url(), 50573735);

        dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        _receiver = address(0x123);

        oracle = new TestOracleSource();
        oracle.setAmountUsdPerToken(2 ether);

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));
        provider.addOracleSource(address(oracle));

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxyDc = Upgrades.deployUUPSProxy(
            "DimoCredit.sol",
            abi.encodeCall(
                DimoCredit.initialize,
                (DC_NAME, DC_SYMBOL, address(dimoToken), _receiver, address(provider), DC_VALIDATION_PERIOD, DC_RATE)
            ),
            opts
        );

        dc = DimoCredit(proxyDc);

        vm.startPrank(0xCED3c922200559128930180d3f0bfFd4d9f4F123); // Foundation
        dimoToken.grantRole(keccak256("BURNER_ROLE"), address(dc));
        vm.stopPrank();
    }

    function test_calc() public {
        address user = address(0x1337);

        deal(address(dimoToken), user, 100 ether);

        vm.startPrank(user);
        dimoToken.approve(address(dc), 100 ether);
        vm.stopPrank();

        dc.mint(user, 100 ether);

        uint256 dcUserBalance = dc.balanceOf(user);
        assertEq(dcUserBalance, 200_000 ether);

        uint256 dimoUserBalance = dimoToken.balanceOf(user);
        assertEq(dimoUserBalance, 0);
    }
}
