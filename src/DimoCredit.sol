// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {IDimoToken} from "./interface/IDimoToken.sol";
import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 *               ______--------___
 *              /|             / |
 *   o___________|_\__________/__|
 *  ]|___     |  |=   ||  =|___  |"
 *  //   \\    |  |____||_///   \\|"
 * |  X  |\--------------/|  X  |\"
 *  \___/                  \___/
 * @title DIMO Credit
 * @custom:version 1.0.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 * @custom:contributor Allyson English (@aesdfghjkl666)
 * 
 * @dev non-transferable, ipso facto no approve logic
 * @notice approve this contract on $DIMO token before minting
 *         address is 0xE261D618a959aFfFd53168Cd07D12E37B26761db
 */
contract DimoCredit is AccessControl {

    /*//////////////////////////////////////////////////////////////
                             Access Controls
    //////////////////////////////////////////////////////////////*/
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant DC_ADMIN_ROLE = keccak256("DC_ADMIN_ROLE");

    address public _receiver; ///@notice receives proceeds from sale of license

    IDimoToken public _dimo;
    NormalizedPriceProvider public _provider;
    uint256 public _periodValidity;

    uint256 constant public SCALING_FACTOR = 1 ether;

    uint256 public _dimoCreditRate; ///@notice 1 DC == $0.001 USD

    function receiver() external view returns (address receiver_) {
        receiver_ = _receiver;
    }

    function dimoCreditRate() external view returns (uint256 dimoCreditRate_) {
        dimoCreditRate_ = _dimoCreditRate;
    }

    function setDimoCreditRate(uint256 dimoCreditRate_) external onlyRole(DC_ADMIN_ROLE) {
        _dimoCreditRate = dimoCreditRate_;
        emit UpdateDimoCreditRate(_dimoCreditRate);
    }

    function setDimoTokenAddress(address dimoTokenAddress_) external onlyRole(DC_ADMIN_ROLE) {
        _dimo = IDimoToken(dimoTokenAddress_);
    }

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_OPERATION = "DimoCredit: invalid operation";

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event UpdateDimoCreditRate(uint256 rate);
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
    constructor(address receiver_, address provider_) {
        
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _dimo = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _provider = NormalizedPriceProvider(provider_);
        _periodValidity = 1 days;

        _receiver = receiver_;

        _dimoCreditRate = 0.001 ether;
    
        decimals = 18;
        symbol = "DCX";
        name = "Dimo Credit";
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
        dimoCredits = usdAmount * _dimoCreditRate;
        
        _mint(amountIn, dimoCredits, to);
    }

    function mintAmountDc(
        address to, 
        uint256 dimoCredits,
        bytes calldata data
        ) external returns(uint256 amountIn) {

        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken(data);

        // Calculate the equivalent USD amount from data credits
        uint256 usdAmount = dimoCredits / _dimoCreditRate;

        // Adjust for precision
        amountIn = (usdAmount * SCALING_FACTOR) / amountUsdPerToken;

        _mint(amountIn, dimoCredits, to);
    }

    /**
     * @dev permissioned because it could cost $LINK to invoke
     */
    function updatePrice(bytes calldata data) external onlyRole(DC_ADMIN_ROLE) {
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
     * https://docs.openzeppelin.com/contracts/4.x/access-control
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