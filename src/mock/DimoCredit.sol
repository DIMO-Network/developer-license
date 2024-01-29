// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {NormalizedPriceProvider} from "./NormalizedPriceProvider.sol";
import {DimoMarketRewards} from "./DimoMarketRewards.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/** 
 * @notice approve this contract on $DIMO token before minting
 * address is 0xE261D618a959aFfFd53168Cd07D12E37B26761db
 * 
 * 1 DC == $0.001 USD
 */
contract DimoDataCredit is ERC20, Ownable2Step {

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

    ERC20 public _dimo;
    address public _marketRewards;
    NormalizedPriceProvider public _provider;
    uint256 public _periodValidity;

    uint256 constant SCALING_FACTOR = 10**18;
    uint256 constant DATA_CREDIT_RATE = 10**3;
    
    constructor() ERC20("Dimo Data Credit", "DCX", 18) Ownable(msg.sender) {
        _dimo = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _marketRewards = 0x2332A085461391595C3127472046EDC39996e141;
        _provider = NormalizedPriceProvider(0x012Ee74d44D7894b8F6B4509CFAFf4620d73C99f);
        _periodValidity = 1 days;
    }

    function initialize(
        address dimo_, 
        address marketRewards_, 
        address provider_, 
        uint256 periodValidity_ 
    ) onlyOwner external {
        _dimo = ERC20(dimo_);
        _marketRewards = marketRewards_;
        _provider = NormalizedPriceProvider(provider_);
        _periodValidity = periodValidity_;
    }

    function burn(address from, uint256 amount) external {
        _burn(from, amount);
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

    function mintOut(
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
        require(_dimo.balanceOf(to) >= amountDimo, "DimoDataCredit: insufficient amount");
        _dimo.transferFrom(to, _marketRewards, amountDimo);
        _mint(to, amountDataCredits);
    }


    function 

}
