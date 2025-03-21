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

//forge test --match-path ./test/credits/Burn.t.sol -vv
contract BurnDimoCreditTest is Test {
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

        dc.grantRole(keccak256("BURNER_ROLE"), address(this));

        vm.startPrank(0xCED3c922200559128930180d3f0bfFd4d9f4F123); // Foundation
        dimoToken.grantRole(keccak256("BURNER_ROLE"), address(dc));
        vm.stopPrank();
    }

    function test_burnSuccess() public {
        address user = address(0x1337);
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), user, amountIn);

        vm.startPrank(user);
        dimoToken.approve(address(dc), amountIn);
        uint256 amountDc = dc.mintInDimo(user, amountIn);
        vm.stopPrank();

        assertEq(dc.balanceOf(user), amountDc);

        dc.burn(user, amountDc);
        assertEq(dc.balanceOf(user), 0);
    }

    function test_burnFail() public {
        address user = address(0x1337);
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), user, amountIn);

        vm.startPrank(user);
        dimoToken.approve(address(dc), amountIn);
        uint256 amountDc = dc.mintInDimo(user, amountIn);
        vm.stopPrank();
        assertEq(dc.balanceOf(user), amountDc);

        vm.startPrank(address(0x123));
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector, address(0x123), dc.BURNER_ROLE()
            )
        );
        dc.burn(user, amountDc);
        vm.stopPrank();
    }

    function test_burnSuccessAddAddressBurnAgainSuccess() public {
        address user = address(0x1337);
        uint256 amountIn = 1 ether;

        deal(address(dimoToken), user, amountIn);

        vm.startPrank(user);
        dimoToken.approve(address(dc), amountIn);
        uint256 amountDc = dc.mintInDimo(user, amountIn);
        vm.stopPrank();

        assertEq(dc.balanceOf(user), amountDc);

        dc.burn(user, 1);
        assertEq(dc.balanceOf(user), amountDc - 1);

        address next = address(0x123);

        dc.grantRole(keccak256("BURNER_ROLE"), next);

        vm.startPrank(next);
        dc.burn(user, 1);
        vm.stopPrank();

        assertEq(dc.balanceOf(user), amountDc - 1 - 1);
    }
}
