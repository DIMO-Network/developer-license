// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

import {IDimoToken} from "./interface/IDimoToken.sol";

/** 
 * 
 * TODO: should we include a way to do EIP-2612 from smart
 * contract accounts? 
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

    // Establish a new OBD device, dash cam, software connection, etc.
    uint256 MINT_DEVICE = 4_500 ether;
    // Mint a new vehicle on DIMO
    uint256 MINT_VEHICLE = 4_500 ether;
    // Pair a device and vehicle
    uint256 PAIR_DEVICE_VEHICLE = 1_000 ether;
    // Transfer a previously minted device to another user
    uint256 TRANSFER_DEVICE = 1_000 ether;
    // Transfer a previously minted vehicle to another user
    uint256 TRANSFER_VEHICLE = 1_000 ether;
    // Unpair a device and vehicle
    uint256 UNPAIR_DEVICE_VEHICLE = 1_000 ether;
    // Update device permissions
    uint256 UPDATE_DEVICE_PERMISSIONS = 200 ether;
    // Update vehicle permissions
    uint256 UPDATE_VEHICLE_PERMISSIONS = 100 ether;
    // Purchase/renew DIMO Canonical Name (DCN)
    uint256 PURCHASE_DCN = 10_000 ether;

    IDimoToken public _dimo;
    address public _marketRewards;
    NormalizedPriceProvider public _provider;
    uint256 public _periodValidity;

    uint256 constant SCALING_FACTOR = 10**18;
    uint256 constant DATA_CREDIT_RATE = 10**3;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

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

    mapping(address => mapping(address => uint256)) public allowance;
    
    /**
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) Ownable(msg.sender) {
        _dimo = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _provider = NormalizedPriceProvider(0x012Ee74d44D7894b8F6B4509CFAFf4620d73C99f);
        _periodValidity = 1 days;
    
        name = name_;
        symbol = symbol_;
        decimals = decimals_;
    }

    function initialize(
        address dimo_, 
        address receiver_, 
        address provider_, 
        uint256 periodValidity_ 
    ) onlyOwner external {
        _dimo = IDimoToken(dimo_);

        _receiver = receiver_;

        _provider = NormalizedPriceProvider(provider_);
        _periodValidity = periodValidity_;
    }

    /**
     * 
     */
    function mint(
        address to, 
        uint256 amountIn,
        bytes calldata data
        ) external {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken(data);

        // Perform the multiplication
        uint256 usdAmount = (amountIn * amountUsdPerToken) / SCALING_FACTOR;

        // Convert USD amount to data credits
        uint256 dataCredits = usdAmount * DATA_CREDIT_RATE;
        
        _mintAndTransfer(amountIn, dataCredits, to);
    }

    function mintAmountOut(
        address to, 
        uint256 dataCredits,
        bytes calldata data
        ) external {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken(data);

        // Calculate the equivalent USD amount from data credits
        uint256 usdAmount = dataCredits / DATA_CREDIT_RATE;

        // Adjust for precision
        uint256 amountIn = (usdAmount * SCALING_FACTOR) / amountUsdPerToken;

        _mintAndTransfer(amountIn, dataCredits, to);
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

    function _mintAndTransfer(uint256 amountDimo, uint256 amountDataCredits, address to) private {
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
}
