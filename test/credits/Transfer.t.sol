// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {EventUtils} from "../helper/EventUtils.sol";
import {IDimoToken} from "../../src/interface/IDimoToken.sol";
import {TwapV3} from "../../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {IDimoCredit} from "../../src/interface/IDimoCredit.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";

//forge test --match-path ./test/credits/Transfer.t.sol -vv
contract MintDimoCreditTest is Test {
    string constant DC_NAME = "DIMO Credit";
    string constant DC_SYMBOL = "DCX";
    uint256 constant DC_VALIDATION_PERIOD = 1 days;
    uint256 constant DC_RATE = 0.001 ether;

    DimoCredit dc;
    IDimoToken dimoToken;
    NormalizedPriceProvider npp;

    address _receiver;
    address _admin;

    function setUp() public {
        _receiver = address(0x123);
        _admin = address(0x1);

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
        dc.grantRole(dc.DC_ADMIN_ROLE(), _admin);
    }

    function testTransferRevertNonAuthorized() public {
        address nonAuthorized = address(0x456);
        uint256 amount = 100;

        vm.startPrank(nonAuthorized);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector, nonAuthorized, dc.TRANSFERER_ROLE()
            )
        );
        dc.transfer(nonAuthorized, amount);
        vm.stopPrank();
    }

    function testTransferSuccessfulWhenAuthorized() public {
        address authorizedUser = address(0x123);
        address recipient = address(0x456);
        uint256 amount = 100;

        deal(address(dc), authorizedUser, amount);

        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedUser);

        vm.prank(authorizedUser);
        bool success = dc.transfer(recipient, amount);

        assertTrue(success);
        assertEq(dc.balanceOf(authorizedUser), 0);
        assertEq(dc.balanceOf(recipient), amount);
    }

    function testTransferCorrectlyUpdatesBalance() public {
        address authorizedSender = address(0x123);
        address receiver = address(0x456);
        uint256 initialBalance = 1000;
        uint256 transferAmount = 100;

        // Set up initial balance for sender
        deal(address(dc), authorizedSender, initialBalance);

        // Authorize sender for transfer
        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        // Perform transfer
        vm.prank(authorizedSender);
        dc.transfer(receiver, transferAmount);

        // Check sender's balance after transfer
        assertEq(
            dc.balanceOf(authorizedSender), initialBalance - transferAmount, "Sender's balance not updated correctly"
        );
    }

    function testTransferCorrectlyUpdatesRecipientBalance() public {
        address authorizedSender = address(0x123);
        address recipient = address(0x456);
        uint256 initialAmount = 1000;
        uint256 transferAmount = 500;

        // Grant authorization to sender
        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        // Mint initial amount to sender
        deal(address(dc), authorizedSender, initialAmount);

        // Perform transfer
        vm.prank(authorizedSender);
        dc.transfer(recipient, transferAmount);

        // Check recipient's balance
        assertEq(dc.balanceOf(recipient), transferAmount, "Recipient balance should be updated correctly");
    }

    function testTransferEmitsTransferEvent() public {
        address authorizedSender = address(this);
        address recipient = address(0x789);
        uint256 amount = 100;

        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        deal(address(dc), authorizedSender, amount);

        vm.expectEmit(true, true, false, true);
        emit DimoCredit.Transfer(authorizedSender, recipient, amount);

        dc.transfer(recipient, amount);
    }

    function testTransferRevertInsufficientBalance() public {
        address authorizedSender = address(0x123);
        address recipient = address(0x456);
        uint256 senderBalance = 100;
        uint256 transferAmount = 150;

        // Set up the sender's balance
        vm.prank(address(dc));
        dc.mint(authorizedSender, senderBalance);

        // Authorize the sender for transfers
        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        // Attempt to transfer more than the sender's balance
        vm.expectRevert(
            abi.encodeWithSelector(
                DimoCredit.InsufficientBalance.selector, authorizedSender, senderBalance, transferAmount
            )
        );
        vm.prank(authorizedSender);
        dc.transfer(recipient, transferAmount);
    }

    function testTransferRevertZeroAddress() public {
        address authorizedSender = address(0x123);
        uint256 amount = 100;

        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        vm.expectRevert(abi.encodeWithSelector(DimoCredit.ZeroAddress.selector));
        vm.prank(authorizedSender);
        dc.transfer(address(0), amount);
    }

    function testTransferDoesNotChangeTotalSupply() public {
        address authorizedSender = address(0x123);
        address recipient = address(0x456);
        uint256 amount = 100;

        // Authorize sender for transfer
        vm.prank(_admin);
        dc.grantRole(dc.TRANSFERER_ROLE(), authorizedSender);

        // Mint initial balance to sender
        deal(address(dc), authorizedSender, amount);

        uint256 initialTotalSupply = dc.totalSupply();

        // Perform transfer
        vm.prank(authorizedSender);
        dc.transfer(recipient, amount);

        // Assert total supply remains unchanged
        assertEq(dc.totalSupply(), initialTotalSupply, "Total supply should not change after transfer");
    }
}
