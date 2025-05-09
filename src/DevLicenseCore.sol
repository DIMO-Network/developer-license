// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {LibString} from "solady/utils/LibString.sol";

import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
import {ILicenseAccountFactory} from "./interface/ILicenseAccountFactory.sol";
import {IDevLicenseDimo} from "./interface/IDevLicenseDimo.sol";
import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {IDevLicenseErrors} from "./interface/IDevLicenseErrors.sol";

/**
 * @title Developer License Core
 * @dev Implements the core functionalities for managing developer licenses within the DIMO ecosystem.
 * @dev To facilitate potential upgrades, this contract employs the Namespaced Storage Layout (https://eips.ethereum.org/EIPS/eip-7201)
 * @notice This contract manages the creation, administration, and validation of developer licenses,
 *         integrating with DIMO's token and credit systems.
 */
contract DevLicenseCore is Initializable, AccessControlUpgradeable, IDevLicenseDimo, IDevLicenseErrors {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseCore
    struct DevLicenseCoreStorage {
        IDimoToken _dimoToken;
        IDimoCredit _dimoCredit;
        NormalizedPriceProvider _provider;
        ILicenseAccountFactory _licenseAccountFactory;
        /// @notice The period after which a signer is considered expired.
        uint256 periodValidity;
        /// @notice Cost of a single license in USD with 18 decimals.
        uint256 _licenseCostInUsd1e18;
        /// @notice Counter to keep track of the issued licenses.
        uint256 _counter;
        /// @notice Address that receives proceeds from the sale of licenses.
        address _receiver;
        mapping(uint256 tokenId => address owner) _ownerOf;
        mapping(uint256 tokenId => address clientId) _tokenIdToClientId;
        mapping(address clientId => uint256 tokenId) _clientIdToTokenId;
        mapping(uint256 tokenId => bytes32 licenseAlias) _tokenIdToAlias;
        mapping(bytes32 licenseAlias => uint256 tokendId) _aliasToTokenId;
        /// @notice Mapping from license ID to signer addresses with their expiration timestamps.
        mapping(uint256 tokenId => mapping(address signer => uint256 expiration)) _signers;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DevLicenseCore")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DEV_LICENSE_CORE_STORAGE_LOCATION =
        0x0ce190eb010f30ee56c6788a4d8c91d6e96b7119e645c5c83b264dc03116d200;
    bytes32 public constant LICENSE_ADMIN_ROLE = keccak256("LICENSE_ADMIN_ROLE");

    function _getDevLicenseCoreStorage() internal pure returns (DevLicenseCoreStorage storage $) {
        assembly {
            $.slot := DEV_LICENSE_CORE_STORAGE_LOCATION
        }
    }

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/

    ///@dev on mint & burn
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event SignerEnabled(uint256 indexed tokenId, address indexed signer);
    event SignerDisabled(uint256 indexed tokenId, address indexed signer);
    event Locked(uint256 indexed tokenId);
    event LicenseAliasSet(uint256 indexed tokenId, string licenseAlias);

    event UpdateLicenseCost(uint256 licenseCost);
    event UpdateReceiverAddress(address receiver_);
    event UpdateDimoTokenAddress(address dimoToken_);
    event UpdatePeriodValidity(uint256 periodValidity);
    event UpdatePriceProviderAddress(address provider);
    event UpdateDimoCreditAddress(address dimoCredit_);
    event UpdateLicenseAccountFactoryAddress(address licenseAccountFactory_);

    /*//////////////////////////////////////////////////////////////
                            Modifiers
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Ensures the caller is the owner of the specified token ID.
     */
    modifier onlyTokenOwner(uint256 tokenId) {
        if (msg.sender != ownerOf(tokenId)) {
            revert InvalidSender(msg.sender);
        }
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes a new instance of the DevLicenseCore contract.
     * @dev Sets up the contract with the necessary addresses and parameters for operation,
     *      including setting up roles, linking to $DIMO token and credit contracts, and initializing
     *      license cost and validity period.
     * @param receiver_ The address where proceeds from the sale of licenses are sent.
     * @param licenseAccountFactory_ The address of the contract responsible for creating new license accounts.
     * @param provider_ Supplies current $DIMO token price to calculate license cost in USD.
     * @param dimoTokenAddress_ The address of the $DIMO token contract.
     * @param dimoCreditAddress_ The address of the DIMO credit contract, an alternative payment method for licenses.
     * @param licenseCostInUsd1e18_ The cost of a single license expressed in USD with 18 decimal places.
     */
    function __DevLicenseCore_init(
        address receiver_,
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_,
        address dimoCreditAddress_,
        uint256 licenseCostInUsd1e18_
    ) internal onlyInitializing {
        __AccessControl_init();

        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        $.periodValidity = 365 days;

        $._receiver = receiver_;

        $._dimoCredit = IDimoCredit(dimoCreditAddress_);
        $._provider = NormalizedPriceProvider(provider_);

        $._licenseAccountFactory = ILicenseAccountFactory(licenseAccountFactory_);
        $._dimoToken = IDimoToken(dimoTokenAddress_);
        $._licenseCostInUsd1e18 = licenseCostInUsd1e18_;

        emit UpdatePeriodValidity($.periodValidity);
        emit UpdateLicenseCost(licenseCostInUsd1e18_);
    }

    /**
     * @notice Returns the DIMO Token address
     */
    function dimoToken() public view returns (address dimoToken_) {
        dimoToken_ = address(_getDevLicenseCoreStorage()._dimoToken);
    }

    /**
     * @notice Returns the DIMO Credit address
     */
    function dimoCredit() public view returns (address dimoCredit_) {
        dimoCredit_ = address(_getDevLicenseCoreStorage()._dimoCredit);
    }

    /**
     * @notice Returns the Provider address
     */
    function provider() public view returns (address provider_) {
        provider_ = address(_getDevLicenseCoreStorage()._provider);
    }

    /**
     * @notice Returns the License Account Factory address
     */
    function licenseAccountFactory() public view returns (address licenseAccountFactory_) {
        licenseAccountFactory_ = address(_getDevLicenseCoreStorage()._licenseAccountFactory);
    }

    /**
     * @notice Returns the period of validity of a Developer License
     */
    function periodValidity() public view returns (uint256 periodValidity_) {
        periodValidity_ = _getDevLicenseCoreStorage().periodValidity;
    }

    /**
     * @notice Returns the Developer License cost in USD (1e18 decimal places)
     */
    function licenseCostInUsd1e18() public view returns (uint256 licenseCostInUsd1e18_) {
        licenseCostInUsd1e18_ = _getDevLicenseCoreStorage()._licenseCostInUsd1e18;
    }

    /**
     * @notice Returns the Receiver address
     */
    function receiver() public view returns (address receiver_) {
        receiver_ = _getDevLicenseCoreStorage()._receiver;
    }

    /**
     * @notice Returns the Client Id address associated to a Developer License token Id
     * @param tokenId The unique identifier for the license token
     */
    function tokenIdToClientId(uint256 tokenId) public view returns (address clientId) {
        clientId = _getDevLicenseCoreStorage()._tokenIdToClientId[tokenId];
    }

    /**
     * @notice Returns the Developer License token Id associated to a Client Id
     * @param clientId The client Id address
     */
    function clientIdToTokenId(address clientId) public view returns (uint256 tokenId) {
        tokenId = _getDevLicenseCoreStorage()._clientIdToTokenId[clientId];
    }

    /**
     * @notice Returns the timestamp when the signer was last enabled, if the signer was not enabled, it returns 0
     * @param tokenId The unique identifier for the license token
     * @param signer The address of the signer to check
     */
    function signers(uint256 tokenId, address signer) public view returns (uint256 timestamp) {
        timestamp = _getDevLicenseCoreStorage()._signers[tokenId][signer];
    }

    /*//////////////////////////////////////////////////////////////
                       Signer a.k.a. API Key
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Enables a signer for a specific token ID, granting the signer permission to access
     *         API functionalities/resources. Only the owner of the token ID can enable a signer.
     *         License can be minted by any EOA and assigned an owner, or by the owner directly.
     *         the owner then enables a key and/or set of keys to act as a signer, to sign challenges
     *         from the backend to access API resources.
     * @dev Emits a `SignerEnabled` event upon successfully adding a signer. This function checks
     *      if the caller owns the token ID and then delegates to `_enableSigner` to update the
     *      mapping of signers.
     * @param tokenId The unique identifier for the license token.
     * @param signer The address to be enabled as a signer for the specified token ID.
     */
    function enableSigner(uint256 tokenId, address signer) external onlyTokenOwner(tokenId) {
        _enableSigner(tokenId, signer);
    }

    /**
     * @notice Disables a signer for a specific token ID.
     *         Only the owner of the token ID can disable a signer.
     * @dev Emits a `SignerDisabled` event upon successfully removing a signer. This function checks
     *      if the caller owns the token ID and then delegates to `_disableSigner` to update the
     *      mapping of signers.
     * @param tokenId The unique identifier for the license token.
     * @param signer The address to be enabled as a signer for the specified token ID.
     */
    function disableSigner(uint256 tokenId, address signer) external onlyTokenOwner(tokenId) {
        _disableSigner(tokenId, signer);
    }

    /**
     * @notice It sets an alias to a token ID
     * @dev Only the token ID owner can call this function
     * @param tokenId The unique identifier for the license token.
     * @param licenseAlias The alias string to be set with limit of 32 bytes
     */
    function setLicenseAlias(uint256 tokenId, string calldata licenseAlias) public onlyTokenOwner(tokenId) {
        _setLicenseAlias(tokenId, licenseAlias);
    }

    /**
     * @notice Internally enables a signer for a specific token ID by recording the current block
     *         timestamp as the time of enabling. This function should only be called through `enableSigner`.
     * @dev Updates the `_signers` mapping to mark the `signer` address as enabled for the `tokenId`.
     *      It records the current block timestamp for the signer.
     * @param tokenId The unique identifier for the license token.
     * @param signer The address to be enabled as a signer for the specified token ID.
     */
    function _enableSigner(uint256 tokenId, address signer) internal {
        _getDevLicenseCoreStorage()._signers[tokenId][signer] = block.timestamp;
        emit SignerEnabled(tokenId, signer);
    }

    /**
     * @notice Internally disables a signer for a specific token ID by deleting the time of enabling.
     * @dev Updates the `_signers` mapping to mark the `signer` address as disabled for the `tokenId`.
     * @param tokenId The unique identifier for the license token.
     * @param signer The address to be enabled as a signer for the specified token ID.
     */
    function _disableSigner(uint256 tokenId, address signer) internal {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        delete $._signers[tokenId][signer];
        emit SignerDisabled(tokenId, signer);
    }

    /**
     * @notice Internal function to set an alias to a token ID
     * @dev The license alias can be up to 32 bytes long
     * @param tokenId The unique identifier for the license token.
     * @param licenseAlias The alias string to be set with limit of 32 bytes
     */
    function _setLicenseAlias(uint256 tokenId, string memory licenseAlias) internal {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        if (bytes(licenseAlias).length > 32) {
            revert AliasExceedsMaxLength();
        }

        bytes32 licenseAliasBytes32;
        assembly {
            licenseAliasBytes32 := mload(add(licenseAlias, 32))
        }

        if ($._aliasToTokenId[licenseAliasBytes32] != 0) {
            revert AliasAlreadyInUse(licenseAlias);
        }

        bytes32 currentLicenseAlias = $._tokenIdToAlias[tokenId];
        if (currentLicenseAlias.length > 0) {
            delete $._aliasToTokenId[currentLicenseAlias];
        }

        $._tokenIdToAlias[tokenId] = licenseAliasBytes32;
        $._aliasToTokenId[licenseAliasBytes32] = tokenId;
        emit LicenseAliasSet(tokenId, licenseAlias);
    }

    /**
     * @notice Checks whether a given address is currently an enabled signer for a specified token ID.
     *         The signer's enabled status is valid only for the period defined by `periodValidity`.
     * @dev This function calculates the difference between the current block timestamp and the timestamp
     *      when the signer was enabled. If the difference exceeds `periodValidity`, the signer is
     *      considered no longer enabled.
     * @param tokenId The unique identifier for the license token.
     * @param signer The address to check for being an enabled signer for the specified token ID.
     * @return isSigner_ Returns true if the `signer` is currently enabled for the `tokenId` and the period of
     *         validity has not expired; otherwise, returns false.
     */
    function isSigner(uint256 tokenId, address signer) public view returns (bool isSigner_) {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        uint256 timestampInit = $._signers[tokenId][signer];
        isSigner_ = (timestampInit != 0) && (block.timestamp - timestampInit <= $.periodValidity);
    }

    /**
     * @notice Returns the expiration timestamp of a signer
     * @dev Calculates the expiration timestamp by adding the period validity to the timestamp when the signer was last enabled.
     *      If the signer was not enabled, it returns 0.
     * @param tokenId The unique identifier for the license token
     * @param signer The address of the signer to check
     */
    function getSignerExpiration(uint256 tokenId, address signer) public view returns (uint256 timestamp) {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        uint256 timestampInit = $._signers[tokenId][signer];
        if (timestampInit == 0) {
            return 0;
        }
        timestamp = timestampInit + $.periodValidity;
    }

    /**
     * @notice It returns the alias associated with a token ID
     * @dev It returns an empty string if no alias is associated with the token ID
     * @param tokenId The unique identifier for the license token.
     */
    function getLicenseAliasByTokenId(uint256 tokenId) public view returns (string memory licenseAlias) {
        bytes32 licenseAliasBytes32 = _getDevLicenseCoreStorage()._tokenIdToAlias[tokenId];
        licenseAlias = LibString.fromSmallString(licenseAliasBytes32);
    }

    /**
     * @notice It returns the token Id associated with a license alias
     * @dev It returns 0 if no token ID is associated with the license alias
     * @param licenseAlias The unique alias for the license token.
     */
    function getTokenIdByLicenseAlias(bytes32 licenseAlias) public view returns (uint256 tokenId) {
        tokenId = _getDevLicenseCoreStorage()._aliasToTokenId[licenseAlias];
    }

    /**
     * @notice It returns the token Id associated with a license alias
     * @dev It returns 0 if no token ID is associated with the license alias
     * @param licenseAlias The unique alias for the license token.
     */
    function getTokenIdByLicenseAlias(string memory licenseAlias) public view returns (uint256 tokenId) {
        if (bytes(licenseAlias).length <= 32) {
            bytes32 licenseAliasBytes32;
            assembly {
                licenseAliasBytes32 := mload(add(licenseAlias, 32))
            }
            tokenId = _getDevLicenseCoreStorage()._aliasToTokenId[licenseAliasBytes32];
        }
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the receiver address to which the payments will be directed.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdateReceiverAddress` event.
     * @param receiver_ The new receiver address.
     */
    function setReceiverAddress(address receiver_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._receiver = receiver_;
        emit UpdateReceiverAddress(receiver_);
    }

    /**
     * @notice Sets the cost of obtaining a license in USD (with 18 decimals).
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdateLicenseCost` event.
     * @param licenseCostInUsd1e18_ The new license cost in USD (1e18 = 1 USD).
     */
    function setLicenseCost(uint256 licenseCostInUsd1e18_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._licenseCostInUsd1e18 = licenseCostInUsd1e18_;
        emit UpdateLicenseCost(licenseCostInUsd1e18_);
    }

    /**
     * @notice Sets the validity period for the license.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdatePeriodValidity` event.
     * @param periodValidity_ The new validity period for the license in seconds.
     */
    function setPeriodValidity(uint256 periodValidity_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage().periodValidity = periodValidity_;
        emit UpdatePeriodValidity(periodValidity_);
    }

    /**
     * @notice Sets the address of the price provider contract.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdatePriceProviderAddress` event.
     * @param providerAddress_ The address of the new price provider contract.
     */
    function setPriceProviderAddress(address providerAddress_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._provider = NormalizedPriceProvider(providerAddress_);
        emit UpdatePriceProviderAddress(providerAddress_);
    }

    /**
     * @notice Sets the address of the DIMO Credit contract.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdateDimoCreditAddress` event.
     * @param dimoCreditAddress_ The address of the DIMO Credit contract.
     */
    function setDimoCreditAddress(address dimoCreditAddress_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._dimoCredit = IDimoCredit(dimoCreditAddress_);
        emit UpdateDimoCreditAddress(dimoCreditAddress_);
    }

    /**
     * @notice Sets the address of the DIMO Token contract.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdateDimoTokenAddress` event.
     * @param dimoTokenAddress_ The address of the DIMO Token contract.
     */
    function setDimoTokenAddress(address dimoTokenAddress_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._dimoToken = IDimoToken(dimoTokenAddress_);
        emit UpdateDimoTokenAddress(dimoTokenAddress_);
    }

    /**
     * @notice Sets the address of the License Account Factory contract.
     * @dev Can only be called by an account with the `LICENSE_ADMIN_ROLE`. Emits `UpdateLicenseAccountFactoryAddress` event.
     * @param licenseAccountFactory_ The address of the License Account Factory contract.
     */
    function setLicenseFactoryAddress(address licenseAccountFactory_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseCoreStorage()._licenseAccountFactory = ILicenseAccountFactory(licenseAccountFactory_);
        emit UpdateLicenseAccountFactoryAddress(licenseAccountFactory_);
    }

    /*//////////////////////////////////////////////////////////////
                             NO-OP NFT Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Prevents approval of token spending by third parties.
     * @dev This contract does not support approvals, attempting to do so will cause a revert.
     */
    function approve(address, /*spender*/ uint256 /*id*/ ) public virtual {
        revert InvalidOperation();
    }

    /**
     * @notice Prevents setting approval for all tokens owned by the caller.
     * @dev This contract does not support setting approval for all, attempting to do so will cause a revert.
     */
    function setApprovalForAll(address, /*operator*/ bool /*approved*/ ) public virtual {
        revert InvalidOperation();
    }

    /**
     * @notice Prevents transferring tokens from one address to another.
     * @dev This contract does not support transferring tokens, attempting to do so will cause a revert.
     */
    function transferFrom(address, /*from*/ address, /*to*/ uint256 /*id*/ ) public virtual {
        revert InvalidOperation();
    }

    /**
     * @notice Prevents safe transferring of tokens from one address to another without data.
     * @dev This contract does not support safe transferring of tokens without data, attempting to do so will cause a revert.
     */
    function safeTransferFrom(address, /*from*/ address, /*to*/ uint256 /*id*/ ) public virtual {
        revert InvalidOperation();
    }

    /**
     * @notice Prevents safe transferring of tokens from one address to another with data.
     * @dev This contract does not support safe transferring of tokens with data, attempting to do so will cause a revert.
     */
    function safeTransferFrom(address, /*from*/ address, /*to*/ uint256, /*id*/ bytes memory /*data*/ )
        public
        virtual
    {
        revert InvalidOperation();
    }

    /*//////////////////////////////////////////////////////////////
                              NFT Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Returns the address of the owner of a given tokenId.
     * @param tokenId The identifier for a token.
     * @return owner The address of the owner of the specified token.
     * @notice The token must exist (tokenId must have been minted).
     */
    function ownerOf(uint256 tokenId) public view virtual returns (address owner) {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        owner = $._ownerOf[tokenId];
        if (owner == address(0)) {
            revert NonexistentToken(tokenId);
        }
    }

    /*//////////////////////////////////////////////////////////////
                            SBT Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev ERC5192: Minimal Soulbound NFTs Minimal interface for
     * soulbinding EIP-721 NFTs
     */
    function locked(uint256 tokenId) external view returns (bool locked_) {
        locked_ = _exists(tokenId);
        if (!locked_) {
            revert NonexistentToken(tokenId);
        }
    }

    /*//////////////////////////////////////////////////////////////
                         Private Helper Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Checks if a token exists by verifying the owner is not the zero address.
     * Tokens are considered to exist if they have been minted and not burned.
     * @param tokenId The identifier for an NFT.
     * @return bool True if the token exists (has an owner other than the zero address), false otherwise.
     */
    function _exists(uint256 tokenId) private view returns (bool) {
        DevLicenseCoreStorage storage $ = _getDevLicenseCoreStorage();

        return $._ownerOf[tokenId] != address(0);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev See {IERC165-supportsInterface}.
     * @notice Checks if the contract implements an interface.
     *         Implements ERC165 to support interface detection for ERC721 (NFT), ERC5192 (Lockable NFT),
     *         and ERC721Metadata.
     * @param interfaceId The interface identifier, as specified in ERC-165.
     * @return bool True if the contract implements `interfaceId` and `interfaceId` is not 0xffffffff,
     *         false otherwise.
     */
    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == 0x80ac58cd // ERC165 Interface ID for ERC721
            || interfaceId == 0xb45a3c0e // ERC165 Interface ID for ERC5192
            || interfaceId == 0x5b5e139f // ERC165 Interface ID for ERC721Metadata
            || super.supportsInterface(interfaceId);
    }
}
