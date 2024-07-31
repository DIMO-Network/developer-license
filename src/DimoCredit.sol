// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import {IDimoToken} from "./interface/IDimoToken.sol";
import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";

//               ______--------___
//              /|             / |
//   o___________|_\__________/__|
//  ]|___     |  |=   ||  =|___  |"
//  //   \\    |  |____||_///   \\|"
// |  X  |\--------------/|  X  |\"
//  \___/                  \___/
/**
 * @title DIMO Credit
 * @custom:version 1.2.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Allyson English (@aesdfghjkl666)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 *
 * @dev Contract for managing non-transferable tokens for use within the DIMO developer ecosystem.
 * @dev To facilitate potential upgrades, this contract employs the Namespaced Storage Layout (https://eips.ethereum.org/EIPS/eip-7201)
 * @notice This contract manages the issuance (minting) and destruction (burning) of DIMO Credits,
 *         leveraging the $DIMO token and a price provider for exchange rate information. Approve
 *         this contract on $DIMO token (0xE261D618a959aFfFd53168Cd07D12E37B26761db) before minting.
 */
contract DimoCredit is Initializable, AccessControlUpgradeable, UUPSUpgradeable {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DimoCredit
    struct DimoCreditStorage {
        uint256 _dimoCreditRateInWei;
        uint256 _periodValidity;
        ///@dev receives proceeds from sale of credits
        address _receiver;
        IDimoToken _dimo;
        NormalizedPriceProvider _provider;
        string _name;
        string _symbol;
        uint256 _totalSupply;
        mapping(address account => uint256 balance) _balanceOf;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DimoCredit")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DIMO_CREDIT_STORAGE_LOCATION =
        0xecac8b0340dd336c3ac98ce70f7645fc65001c59d70f7941ce9a0837ff7b7c00;

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant DC_ADMIN_ROLE = keccak256("DC_ADMIN_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    function _getDimoCreditStorage() private pure returns (DimoCreditStorage storage $) {
        assembly {
            $.slot := DIMO_CREDIT_STORAGE_LOCATION
        }
    }

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    ///@dev only used in mint and burn, not transferable
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event UpdateDimoCreditRate(uint256 rate);
    event UpdateDimoTokenAddress(address indexed dimo_);
    event UpdateReceiverAddress(address indexed receiver_);
    event UpdatePeriodValidity(uint256 periodValidity);
    event UpdatePriceProviderAddress(address indexed provider);

    error InvalidOperation();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the contract with specified parameters
     * @param name_ The ERC20 name
     * @param symbol_ The ERC20 symbol
     * @param dimoToken_ The address of the ERC20 DIMO Token
     * @param receiver_ The address where proceeds from the sale of credits are sent
     * @param provider_ The address of the price provider used to determine the exchange rate for DIMO Credits
     * @param periodValidity_  The period for which a price update is considered valid
     * @param dimoCreditRateInWei_ The exchange rate for converting DIMO to DIMO Credits
     */
    function initialize(
        string calldata name_,
        string calldata symbol_,
        address dimoToken_,
        address receiver_,
        address provider_,
        uint256 periodValidity_,
        uint256 dimoCreditRateInWei_
    ) external initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        DimoCreditStorage storage $ = _getDimoCreditStorage();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        $._dimo = IDimoToken(dimoToken_);
        $._provider = NormalizedPriceProvider(provider_);
        $._periodValidity = periodValidity_;

        $._receiver = receiver_;
        $._dimoCreditRateInWei = dimoCreditRateInWei_;

        $._symbol = symbol_;
        $._name = name_;
    }

    /**
     * @notice Returns the current exchange rate for converting DIMO to DIMO Credits
     */
    function dimoCreditRate() external view returns (uint256) {
        return _getDimoCreditStorage()._dimoCreditRateInWei;
    }

    /**
     * @notice Returns the period for which a price update is considered valid
     */
    function periodValidity() external view returns (uint256) {
        return _getDimoCreditStorage()._periodValidity;
    }

    /**
     * @notice Returns the current receiver address for DIMO token proceeds
     */
    function receiver() external view returns (address) {
        return _getDimoCreditStorage()._receiver;
    }

    /**
     * @notice Returns the DIMO Token address
     */
    function dimoToken() external view returns (address) {
        return address(_getDimoCreditStorage()._dimo);
    }

    /**
     * @notice Returns the address of the price provider used to determine the exchange rate for DIMO Credits
     */
    function provider() external view returns (address) {
        return address(_getDimoCreditStorage()._provider);
    }

    /**
     * @notice Returns the number of decimal places of this ERC20
     */
    function decimals() external pure returns (uint8) {
        return 18;
    }

    /**
     * @notice Returns the name of this ERC20
     */
    function name() external view returns (string memory) {
        return _getDimoCreditStorage()._name;
    }

    /**
     * @notice Returns the symbol of this ERC20
     */
    function symbol() external view returns (string memory) {
        return _getDimoCreditStorage()._symbol;
    }

    /**
     * @notice Returns the total supply of this ERC20
     */
    function totalSupply() external view returns (uint256) {
        return _getDimoCreditStorage()._totalSupply;
    }

    /**
     * @notice Returns the balance of an account
     * @param account The account address
     */
    function balanceOf(address account) external view returns (uint256) {
        return _getDimoCreditStorage()._balanceOf[account];
    }

    /**
     * @notice Mints DIMO Credits to a specified address based on the provided DIMO token amount.
     * @dev Converts the amount of DIMO tokens to DIMO Credits using the current exchange rate from the price provider.
     * @dev Any amount of $DIMO exchanged for $DCX will be burned.
     * @param to The address to receive the minted non-transferable DIMO Credits.
     * @param amountDimoTokens The amount of DIMO tokens to convert.
     * @return dimoCredits The amount of DIMO Credits minted.
     */
    function mintInDimo(address to, uint256 amountDimoTokens) external returns (uint256 dimoCredits) {
        dimoCredits = mintInDimo(to, amountDimoTokens, "");
    }

    /**
     * @notice Mints DIMO Credits to a specified address based on the provided DIMO token amount.
     * @dev Converts the amount of DIMO tokens to DIMO Credits using the current exchange rate from the price provider.
     * @dev Any amount of $DIMO exchanged for $DCX will be burned.
     * @param to The address to receive the minted non-transferable DIMO Credits.
     * @param amountDimoTokens The amount of DIMO tokens to convert.
     * @param data Additional data required by the price provider to determine the exchange rate (Optional).
     * @return dimoCredits The amount of DIMO Credits minted.
     */
    function mintInDimo(address to, uint256 amountDimoTokens, bytes memory data) public returns (uint256 dimoCredits) {
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        (uint256 amountUsdPerTokenInWei,) = $._provider.getAmountUsdPerToken(data);

        // Perform the multiplication
        uint256 usdAmountInWei = (amountDimoTokens * amountUsdPerTokenInWei);

        // Convert USD amount to DIMO credits
        dimoCredits = (usdAmountInWei / $._dimoCreditRateInWei);

        _mint(to, amountDimoTokens, dimoCredits);
    }

    /**
     * @notice Mints DIMO Credits to a specified address based on the provided DIMO token amount.
     * @dev Calculates the amount of DIMO tokens needed to mint the equivalent amount of DIMO Credits.
     * @dev Converts the amount of DIMO tokens to DIMO Credits using the current exchange rate from the price provider.
     * @dev Any amount of $DIMO exchanged for $DCX will be burned.
     * @param to The address to receive the minted non-transferable DIMO Credits.
     * @param amountDimoCredits The amount of DIMO Credits to be minted.
     */
    function mint(address to, uint256 amountDimoCredits) external {
        mint(to, amountDimoCredits, "");
    }

    /**
     * @notice Mints DIMO Credits to a specified address based on the provided DIMO token amount.
     * @dev Calculates the amount of DIMO tokens needed to mint the equivalent amount of DIMO Credits.
     * @dev Converts the amount of DIMO tokens to DIMO Credits using the current exchange rate from the price provider.
     * @dev Any amount of $DIMO exchanged for $DCX will be burned.
     * @param to The address to receive the minted non-transferable DIMO Credits.
     * @param amountDimoCredits The amount of DIMO Credits to be minted.
     * @param data Additional data required by the price provider to determine the exchange rate (Optional).
     */
    function mint(address to, uint256 amountDimoCredits, bytes memory data) public {
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        (uint256 amountUsdPerDimoTokenWei,) = $._provider.getAmountUsdPerToken(data);

        // Convert DIMO credits to USD amount
        uint256 usdAmountInWei = amountDimoCredits * $._dimoCreditRateInWei;
        uint256 amountDimoTokens = usdAmountInWei / amountUsdPerDimoTokenWei;

        _mint(to, amountDimoTokens, amountDimoCredits);
    }

    /**
     * @dev Internal function to handle the mechanics of minting DIMO Credits.
     * @dev Any amount of $DIMO exchanged for $DCX will be burned.
     * @param to The address to receive the minted credits.
     * @param amountDimo The amount of DIMO tokens used for minting.
     * @param amountDimoCredits The amount of DIMO Credits to mint.
     */
    function _mint(address to, uint256 amountDimo, uint256 amountDimoCredits) private {
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        $._dimo.transferFrom(_msgSender(), address(this), amountDimo);
        $._dimo.burn(address(this), amountDimo);

        $._totalSupply += amountDimoCredits;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            $._balanceOf[to] += amountDimoCredits;
        }

        emit Transfer(address(0), to, amountDimoCredits);
    }

    /**
     * @notice Burns DIMO Credits from a specified address.
     * @dev Only addresses with the BURNER_ROLE can call this function.
     * @param from The address from which DIMO Credits will be burned.
     * @param amount The amount of DIMO Credits to burn.
     */
    function burn(address from, uint256 amount) external onlyRole(BURNER_ROLE) {
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        $._balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            $._totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }

    /*//////////////////////////////////////////////////////////////
                            NO-OP ERC20 Logic
    //////////////////////////////////////////////////////////////*/

    /// @notice Prevents transferring of DIMO Credits.
    function transfer(address, /*_to*/ uint256 /*_value*/ ) public pure returns (bool /*success*/ ) {
        revert InvalidOperation();
    }

    /// @notice Prevents transferring of DIMO Credits from one address to another.
    function transferFrom(address, /*_from*/ address, /*_to*/ uint256 /*_value*/ )
        public
        pure
        returns (bool /*success*/ )
    {
        revert InvalidOperation();
    }

    /// @notice Prevents approval of DIMO Credits for spending by third parties.
    function approve(address, /*_spender*/ uint256 /*_value*/ ) public pure returns (bool /*success*/ ) {
        revert InvalidOperation();
    }

    /// @notice Prevents checking allowance of DIMO Credits.
    function allowance(address, /*_owner*/ address /*_spender*/ ) public pure returns (uint256 /*remaining*/ ) {
        revert InvalidOperation();
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
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        (, uint256 updateTimestamp) = $._provider.getAmountUsdPerToken(data);
        bool invalid = (block.timestamp - updateTimestamp) < $._periodValidity;
        bool updatable = $._provider.isUpdatable();

        if (invalid && updatable) {
            $._provider.updatePrice();
        }
    }

    /**
     * @notice Sets a new exchange rate for converting DIMO to DIMO Credits.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param dimoCreditRateInWei_ The new exchange rate in wei.
     */
    function setDimoCreditRate(uint256 dimoCreditRateInWei_) external onlyRole(DC_ADMIN_ROLE) {
        _getDimoCreditStorage()._dimoCreditRateInWei = dimoCreditRateInWei_;
        emit UpdateDimoCreditRate(dimoCreditRateInWei_);
    }

    /**
     * @notice Updates the address of the DIMO token contract.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param dimoTokenAddress_ The new address of the DIMO token contract.
     */
    function setDimoTokenAddress(address dimoTokenAddress_) external onlyRole(DC_ADMIN_ROLE) {
        _getDimoCreditStorage()._dimo = IDimoToken(dimoTokenAddress_);
        emit UpdateDimoTokenAddress(dimoTokenAddress_);
    }

    /**
     * @notice Updates the address of the price provider contract.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param providerAddress_ The new address of the price provider contract.
     */
    function setPriceProviderAddress(address providerAddress_) external onlyRole(DC_ADMIN_ROLE) {
        _getDimoCreditStorage()._provider = NormalizedPriceProvider(providerAddress_);
        emit UpdatePriceProviderAddress(providerAddress_);
    }

    /**
     * @notice Updates the receiver address for DIMO token proceeds from the sale of DIMO Credits.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param receiver_ The new receiver address.
     */
    function setReceiverAddress(address receiver_) external onlyRole(DC_ADMIN_ROLE) {
        _getDimoCreditStorage()._receiver = receiver_;
        emit UpdateReceiverAddress(receiver_);
    }

    /**
     * @notice Sets the period for which a price update is considered valid.
     * @dev This function can only be called by accounts with the DC_ADMIN_ROLE.
     * @param periodValidity_ The new validity period in seconds.
     */
    function setPeriodValidity(uint256 periodValidity_) external onlyRole(DC_ADMIN_ROLE) {
        _getDimoCreditStorage()._periodValidity = periodValidity_;
        emit UpdatePeriodValidity(periodValidity_);
    }

    /**
     * @notice Gets the quote of $DCX for 1 $DIMO
     * @dev Gets the last recorded amount of USD per $DIMO to perform the calculation
     * @return quote The quote of $DCX
     */
    function getQuote() external view returns (uint256 quote) {
        return getQuote(1 ether);
    }

    /**
     * @notice Gets the quote of $DCX for a given value of $DIMO
     * @dev Gets the last recorded amount of USD per $DIMO to perform the calculation
     * @return quote The quote of $DCX
     */
    function getQuote(uint256 amountDimoTokens) public view returns (uint256 quote) {
        DimoCreditStorage storage $ = _getDimoCreditStorage();

        (uint256 lastAmountUsdPerToken,) = $._provider.getLastAmountUsdPerToken();
        uint256 usdAmountInWei = (amountDimoTokens * lastAmountUsdPerToken);

        // Convert USD amount to DIMO credits
        quote = (usdAmountInWei / $._dimoCreditRateInWei);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
