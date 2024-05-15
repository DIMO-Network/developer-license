// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IDimoToken} from "./interface/IDimoToken.sol";
import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

//               ______--------___
//              /|             / |
//   o___________|_\__________/__|
//  ]|___     |  |=   ||  =|___  |"
//  //   \\    |  |____||_///   \\|"
// |  X  |\--------------/|  X  |\"
//  \___/                  \___/
/**
 * @title DIMO Credit
 * @custom:version 1.0.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Allyson English (@aesdfghjkl666)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 *
 * @dev Contract for managing non-transferable tokens for use within the DIMO developer ecosystem.
 * @notice This contract manages the issuance (minting) and destruction (burning) of DIMO Credits,
 *         leveraging the $DIMO token and a price provider for exchange rate information. Approve
 *         this contract on $DIMO token (0xE261D618a959aFfFd53168Cd07D12E37B26761db) before minting.
 */
contract DimoCredit is AccessControl {
    /*//////////////////////////////////////////////////////////////
                             Access Controls
    //////////////////////////////////////////////////////////////*/

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant DC_ADMIN_ROLE = keccak256("DC_ADMIN_ROLE");

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/

    uint256 public _dimoCreditRateInWei;
    uint256 public _periodValidity;

    ///@dev receives proceeds from sale of credits
    address public _receiver;

    IDimoToken public _dimo;
    NormalizedPriceProvider public _provider;

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    uint8 public immutable decimals;

    string public name;
    string public symbol;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/

    string INVALID_OPERATION = "DimoCredit: invalid operation";

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    ///@dev only used in mint and burn, not transferable
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event UpdateDimoCreditRate(uint256 rate);
    event UpdateDimoTokenAddress(address dimo_);
    event UpdateReceiverAddress(address receiver_);
    event UpdatePeriodValidity(uint256 periodValidity);
    event UpdatePriceProviderAddress(address provider);

    /**
     * @notice Initializes the contract with specified receiver and price provider addresses.
     *         Exchange rate determined to be 1 DC == $0.001 USD (1000000000000000 Wei).
     * @param receiver_ The address where proceeds from the sale of credits are sent.
     * @param provider_ The address of the price provider used to determine the exchange rate for DIMO Credits.
     */
    constructor(address receiver_, address provider_) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _dimo = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _provider = NormalizedPriceProvider(provider_);
        _periodValidity = 1 days;

        _receiver = receiver_;
        _dimoCreditRateInWei = 0.001 ether;

        decimals = 18;
        symbol = "DCX";
        name = "Dimo Credit";
    }

    /**
     * @notice Mints DIMO Credits to a specified address based on the provided DIMO token amount.
     * @dev Converts the amount of DIMO tokens to DIMO Credits using the current exchange rate from the price provider.
     * @param to The address to receive the minted non-transferable DIMO Credits.
     * @param amountIn The amount of DIMO tokens to convert.
     * @param data Additional data required by the price provider to determine the exchange rate (Optional).
     * @return dimoCredits The amount of DIMO Credits minted.
     */
    function mint(address to, uint256 amountIn, bytes calldata data) external returns (uint256 dimoCredits) {
        (uint256 amountUsdPerTokenInWei,) = _provider.getAmountUsdPerToken(data);

        // Perform the multiplication
        uint256 usdAmountInWei = (amountIn * amountUsdPerTokenInWei);

        // Convert USD amount to data credits
        dimoCredits = (usdAmountInWei / _dimoCreditRateInWei);

        _mint(amountIn, dimoCredits, to);
    }

    /**
     * @dev Internal function to handle the mechanics of minting DIMO Credits.
     * @param amountDimo The amount of DIMO tokens used for minting.
     * @param amountDataCredits The amount of DIMO Credits to mint.
     * @param to The address to receive the minted credits.
     */
    function _mint(uint256 amountDimo, uint256 amountDataCredits, address to) private {
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
     * @notice Burns DIMO Credits from a specified address.
     * @dev Only addresses with the BURNER_ROLE can call this function.
     * @param from The address from which DIMO Credits will be burned.
     * @param amount The amount of DIMO Credits to burn.
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

    /// @notice Prevents transferring of DIMO Credits.
    function transfer(address, /*_to*/ uint256 /*_value*/ ) public view returns (bool /*success*/ ) {
        revert(INVALID_OPERATION);
    }

    /// @notice Prevents transferring of DIMO Credits from one address to another.
    function transferFrom(address, /*_from*/ address, /*_to*/ uint256 /*_value*/ )
        public
        view
        returns (bool /*success*/ )
    {
        revert(INVALID_OPERATION);
    }

    /// @notice Prevents approval of DIMO Credits for spending by third parties.
    function approve(address, /*_spender*/ uint256 /*_value*/ ) public view returns (bool /*success*/ ) {
        revert(INVALID_OPERATION);
    }

    /// @notice Prevents checking allowance of DIMO Credits.
    function allowance(address, /*_owner*/ address /*_spender*/ ) public view returns (uint256 /*remaining*/ ) {
        revert(INVALID_OPERATION);
    }

    /*//////////////////////////////////////////////////////////////
                          Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Updates the exchange rate for DIMO Credits based on new data from the price provider.
     *         Permissioned because it could cost $LINK to invoke. Can be called by accounts with the
     *         DC_ADMIN_ROLE. It checks if the price update is necessary and valid based on the
     *         _periodValidity.
     * @param data The data required by the price provider for updating the exchange rate.
     */
    function updatePrice(bytes calldata data) external onlyRole(DC_ADMIN_ROLE) {
        (, uint256 updateTimestamp) = _provider.getAmountUsdPerToken(data);
        bool invalid = (block.timestamp - updateTimestamp) < _periodValidity;
        bool updatable = _provider.isUpdatable();

        if (invalid && updatable) {
            _provider.updatePrice();
        }
    }

    /**
     * @notice Sets a new exchange rate for converting DIMO to DIMO Credits.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param dimoCreditRateInWei_ The new exchange rate in wei.
     */
    function setDimoCreditRate(uint256 dimoCreditRateInWei_) external onlyRole(DC_ADMIN_ROLE) {
        _dimoCreditRateInWei = dimoCreditRateInWei_;
        emit UpdateDimoCreditRate(_dimoCreditRateInWei);
    }

    /**
     * @notice Updates the address of the DIMO token contract.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param dimoTokenAddress_ The new address of the DIMO token contract.
     */
    function setDimoTokenAddress(address dimoTokenAddress_) external onlyRole(DC_ADMIN_ROLE) {
        _dimo = IDimoToken(dimoTokenAddress_);
        emit UpdateDimoTokenAddress(dimoTokenAddress_);
    }

    /**
     * @notice Updates the address of the price provider contract.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param providerAddress_ The new address of the price provider contract.
     */
    function setPriceProviderAddress(address providerAddress_) external onlyRole(DC_ADMIN_ROLE) {
        _provider = NormalizedPriceProvider(providerAddress_);
        emit UpdatePriceProviderAddress(providerAddress_);
    }

    /**
     * @notice Updates the receiver address for DIMO token proceeds from the sale of DIMO Credits.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param receiver_ The new receiver address.
     */
    function setReceiverAddress(address receiver_) external onlyRole(DC_ADMIN_ROLE) {
        _receiver = receiver_;
        emit UpdateReceiverAddress(_receiver);
    }

    /**
     * @notice Sets the period for which a price update is considered valid.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param periodValidity_ The new validity period in seconds.
     */
    function setPeriodValidity(uint256 periodValidity_) external onlyRole(DC_ADMIN_ROLE) {
        _periodValidity = periodValidity_;
        emit UpdatePeriodValidity(_periodValidity);
    }

    /*//////////////////////////////////////////////////////////////
                            View Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Retrieves the current receiver address for DIMO token proceeds.
     * @return receiver_ The current receiver address.
     */
    function receiver() external view returns (address receiver_) {
        receiver_ = _receiver;
    }

    /**
     * @notice Gets the current exchange rate for converting DIMO to DIMO Credits.
     * @return dimoCreditRateInWei_ The current exchange rate in wei.
     */
    function dimoCreditRate() external view returns (uint256 dimoCreditRateInWei_) {
        dimoCreditRateInWei_ = _dimoCreditRateInWei;
    }
}
