// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

import {IDimoToken} from "./interface/IDimoToken.sol";

/** 
 * 
 * @dev they're not transferable, so there's no approve logic.
 * 
 * @notice approve this contract on $DIMO token before minting
 * address is 0xE261D618a959aFfFd53168Cd07D12E37B26761db
 * 
 * 1 DC == $0.001 USD
 */
contract DimoCredit is Ownable2Step, AccessControl {

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    // TODO: _receiver to then burn or send to rewards smart contract
    // or whatever *this happens on MINT* (gnosis safe)
    address public _receiver;

    function receiver() external view returns (address) {
        return _receiver;
    }

    IDimoToken public _dimo;
    NormalizedPriceProvider public _provider;
    uint256 public _periodValidity;

    uint256 constant SCALING_FACTOR = 10**18;
    uint256 constant DIMO_CREDIT_RATE = 10**3;

    function dimoCreditRate() external pure returns (uint256) {
        return DIMO_CREDIT_RATE;
    }

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_OPERATION = "DimoCredit: invalid operation";

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    ///@dev only used in mint and burn, not transferable
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/
    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    
    /**
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        address receiver_,
        address provider_
    ) Ownable(msg.sender) {

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _dimo = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _provider = NormalizedPriceProvider(provider_);
        _periodValidity = 1 days;

        _receiver = receiver_;
    
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    /**
     * 
     */
    function mint(
        address to, 
        uint256 amountIn,
        bytes calldata data
        ) external returns(uint256 dimoCredits) {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken(data);

        // Perform the multiplication
        uint256 usdAmount = (amountIn * amountUsdPerToken) / SCALING_FACTOR;

        // Convert USD amount to data credits
        dimoCredits = usdAmount * DIMO_CREDIT_RATE;
        
        _mint(amountIn, dimoCredits, to);
    }

    function mintAmountDc(
        address to, 
        uint256 dimoCredits,
        bytes calldata data
        ) external returns(uint256 amountIn) {

        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken(data);

        // Calculate the equivalent USD amount from data credits
        uint256 usdAmount = dimoCredits / DIMO_CREDIT_RATE;

        // Adjust for precision
        amountIn = (usdAmount * SCALING_FACTOR) / amountUsdPerToken;

        _mint(amountIn, dimoCredits, to);
    }

    /**
     * @dev permissioned because it could cost $LINK to invoke
     */
    function updatePrice(bytes calldata data) onlyOwner public {
        (,uint256 updateTimestamp) = _provider.getAmountUsdPerToken(data);
        bool invalid = (block.timestamp - updateTimestamp) < _periodValidity;
        bool updatable = _provider.isUpdatable();
        
        if(invalid && updatable){
            _provider.updatePrice();
        }
    }

    function _mint(uint256 amountDimo, uint256 amountDataCredits, address to) private {
        require(_dimo.balanceOf(to) >= amountDimo, "DimoCredit: insufficient amount");

        _dimo.transferFrom(to, _receiver, amountDimo);

        totalSupply += amountDataCredits;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amountDataCredits;
        }

        emit Transfer(address(0), to, amountDataCredits);
    }

    /**
     * TODO: https://docs.openzeppelin.com/contracts/4.x/access-control
     */
    function burn(address from, uint256 amount) external onlyRole(BURNER_ROLE) {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }

    /*//////////////////////////////////////////////////////////////
                            NO-OP ERC20 Logic
    //////////////////////////////////////////////////////////////*/

    function transfer(address /*_to*/, uint256 /*_value*/) public view returns (bool /*success*/) {
        revert(INVALID_OPERATION);
    }

    function transferFrom(address /*_from*/, address /*_to*/, uint256 /*_value*/) public view returns (bool /*success*/) {
        revert(INVALID_OPERATION);
    }

    function approve(address /*_spender*/, uint256 /*_value*/) public view returns (bool /*success*/) {
        revert(INVALID_OPERATION);
    }

    function allowance(address /*_owner*/, address /*_spender*/) public view returns (uint256 /*remaining*/) {
        revert(INVALID_OPERATION);
    }

}
