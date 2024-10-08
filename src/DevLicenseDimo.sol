// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {DevLicenseMeta} from "./DevLicenseMeta.sol";
import {DevLicenseCore} from "./DevLicenseCore.sol";

//                     _..-------++._
//                 _.-'/ |      _||  \"--._
//           __.--'`._/_\j_____/_||___\    `----.
//      _.--'_____    |          \     _____    /
//   _j    /,---.\   |        =o |   /,---.\   |_
//  [__]==// .-. \\==`===========/==// .-. \\=[__]
//    `-._|\ `-' /|___\_________/___|\ `-' /|_.'
//          `---'                     `---'
/**
 * @title DIMO Developer License
 * @custom:version 1.0.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 * @custom:contributor Allyson English (@aesdfghjkl666)
 * @custom:contributor James Li (@ilsemaj)
 * @dev Implements the DIMO Developer License system, enabling the minting, management, and revocation of developer
 *      licenses on the DIMO platform. Incorporates functionalities for redirect URI management and license issuance
 *      through DIMO tokens or DIMO Credits.
 * @dev To facilitate potential upgrades, this contract employs the Namespaced Storage Layout (https://eips.ethereum.org/EIPS/eip-7201)
 */
contract DevLicenseDimo is Initializable, DevLicenseMeta, UUPSUpgradeable {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseDimo
    struct DevLicenseDimoStorage {
        /// @notice The name of the token (license).
        string _name;
        /// @notice The symbol of the token (license).
        string _symbol;
        /// @dev Tracks the enabled status of redirect URIs for each tokenId.
        mapping(uint256 tokenId => mapping(string redirectUri => bool enabled)) _redirectUris;
    }

    /// @notice Role identifier for addresses authorized to revoke licenses.
    bytes32 public constant REVOKER_ROLE = keccak256("REVOKER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DevLicenseDimo")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DEV_LICENSE_DIMO_STORAGE_LOCATION =
        0x3ec62ea9233f9c7540d233a460e4ee7db69eb3bd4222a12045874d0a665b4300;

    function _getDevLicenseDimoStorage() internal pure returns (DevLicenseDimoStorage storage $) {
        assembly {
            $.slot := DEV_LICENSE_DIMO_STORAGE_LOCATION
        }
    }

    /// @notice Emitted when a redirect URI is enabled for a license.
    event RedirectUriEnabled(uint256 indexed tokenId, string uri);
    /// @notice Emitted when a redirect URI is disabled for a license.
    event RedirectUriDisabled(uint256 indexed tokenId, string uri);
    /// @notice Emitted when a license is issued to an owner and associated with a clientId.
    event Issued(uint256 indexed tokenId, address indexed owner, address indexed clientId);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Sets initial values for `name` and `symbol`, and forwards constructor parameters to the DevLicenseMeta contract.
     */
    function initialize(
        address receiver_,
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_,
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_,
        string calldata image_,
        string calldata description_
    ) external initializer {
        __UUPSUpgradeable_init();
        __DevLicenseMeta_init(image_, description_);
        __DevLicenseCore_init(
            receiver_, licenseAccountFactory_, provider_, dimoTokenAddress_, dimoCreditAddress_, licenseCostInUsd_
        );

        DevLicenseDimoStorage storage $ = _getDevLicenseDimoStorage();

        $._symbol = "DLX";
        $._name = "DIMO Developer License";
    }

    /**
     * @notice Returns the ERC721 name
     */
    function name() public view returns (string memory name_) {
        name_ = _getDevLicenseDimoStorage()._name;
    }

    /**
     * @notice Returns the ERC721 symbol
     */
    function symbol() public view returns (string memory symbol_) {
        symbol_ = _getDevLicenseDimoStorage()._symbol;
    }

    /*//////////////////////////////////////////////////////////////
                            Redirect URI
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the enabled status of a redirect URI for a specific license.
     * @param tokenId The ID of the license.
     * @param uri The redirect URI to check.
     * @return enabled True if the URI is enabled, false otherwise.
     */
    function redirectUriStatus(uint256 tokenId, string calldata uri) external view returns (bool enabled) {
        enabled = _getDevLicenseDimoStorage()._redirectUris[tokenId][uri];
    }

    /**
     * @notice Enables or disables a redirect URI for a license.
     * @dev Only callable by the license owner.
     * @param tokenId The ID of the license.
     * @param enabled True to enable the URI, false to disable it.
     * @param uri The redirect URI to modify.
     */
    function setRedirectUri(uint256 tokenId, bool enabled, string calldata uri) external onlyTokenOwner(tokenId) {
        DevLicenseDimoStorage storage $ = _getDevLicenseDimoStorage();
        if (enabled) {
            $._redirectUris[tokenId][uri] = enabled;
            emit RedirectUriEnabled(tokenId, uri);
        } else {
            delete $._redirectUris[tokenId][uri];
            emit RedirectUriDisabled(tokenId, uri);
        }
    }

    /*//////////////////////////////////////////////////////////////
                            License Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Issues a license in exchange for DIMO tokens.
     * @param licenseAlias The license alias to be set (optional)
     * @return tokenId The ID of the issued license.
     * @return clientId The ID of the client associated with the issued license.
     */
    function issueInDimo(string calldata licenseAlias) external returns (uint256 tokenId, address clientId) {
        return issueInDimo(msg.sender, licenseAlias);
    }

    /**
     * @notice Issues a new license to a specified address in exchange for DIMO tokens.
     *         Transfers spent $DIMO to the receiver address.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set (optional)
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDimo(address to, string calldata licenseAlias) public returns (uint256 tokenId, address clientId) {
        DevLicenseCoreStorage storage dlcs = _getDevLicenseCoreStorage();

        (uint256 amountUsdPerToken,) = dlcs._provider.getAmountUsdPerToken();

        uint256 tokenTransferAmount = (dlcs._licenseCostInUsd1e18 / amountUsdPerToken) * 1 ether;

        dlcs._dimoToken.transferFrom(to, dlcs._receiver, tokenTransferAmount);

        return _issue(to, licenseAlias);
    }

    /**
     * @notice Issues a new license in exchange for DIMO Credits (DC).
     * @dev This function is a wrapper over `issueInDc(address to)` for the sender.
     * @param licenseAlias The license alias to be set (optional)
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDc(string calldata licenseAlias) external returns (uint256 tokenId, address clientId) {
        return issueInDc(msg.sender, licenseAlias);
    }

    /**
     * @notice Issues a new license to a specified address in exchange for DIMO Credits.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set (optional)
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDc(address to, string calldata licenseAlias) public returns (uint256 tokenId, address clientId) {
        DevLicenseCoreStorage storage dlcs = _getDevLicenseCoreStorage();

        uint256 dcTransferAmount = (dlcs._licenseCostInUsd1e18 / dlcs._dimoCredit.dimoCreditRate()) * 1 ether;
        dlcs._dimoCredit.burn(to, dcTransferAmount);

        return _issue(to, licenseAlias);
    }

    /**
     * @dev Internal function to handle the issuance of a new license.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function _issue(address to, string calldata licenseAlias) private returns (uint256 tokenId, address clientId) {
        DevLicenseCoreStorage storage dlcs = _getDevLicenseCoreStorage();

        tokenId = ++dlcs._counter;
        clientId = dlcs._licenseAccountFactory.create(tokenId);

        dlcs._tokenIdToClientId[tokenId] = clientId;
        dlcs._clientIdToTokenId[clientId] = tokenId;
        dlcs._ownerOf[tokenId] = to;

        emit Issued(tokenId, to, clientId);

        /// Calling it here to emit LicenseAliasSet after Issued event
        if (bytes(licenseAlias).length > 0) {
            _setLicenseAlias(tokenId, licenseAlias);
        }

        /// @dev Indicates the license is locked according to ERC5192.
        emit Locked(tokenId);
        /// @dev Indicates the transfer of the newly minted token according to ERC721.
        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @notice Revokes a license, removing it from the owner and marking it as burned.
     * @dev Can only be called by addresses with the REVOKER_ROLE. Requires the license to have no staked funds.
     * @param tokenId The ID of the license to revoke.
     */
    function revoke(uint256 tokenId) external onlyRole(REVOKER_ROLE) {
        DevLicenseCoreStorage storage dlcs = _getDevLicenseCoreStorage();
        DevLicenseStakeStorage storage dlss = _getDevLicenseStakeStorage();

        if (dlss._stakedBalances[tokenId] != 0) {
            revert StakedFunds(tokenId);
        }

        address tokenOwner = dlcs._ownerOf[tokenId];
        delete dlcs._ownerOf[tokenId];

        address clientId = dlcs._tokenIdToClientId[tokenId];
        delete dlcs._tokenIdToClientId[tokenId];
        delete dlcs._clientIdToTokenId[clientId];

        bytes32 licenseAlias = dlcs._tokenIdToAlias[tokenId];
        if (licenseAlias.length > 0) {
            delete dlcs._tokenIdToAlias[tokenId];
            delete dlcs._aliasToTokenId[licenseAlias];
        }

        emit Transfer(tokenOwner, address(0), tokenId);
    }

    /**
     * @notice Internal function to authorize contract upgrade
     * @dev Caller must have the upgrader role
     * @param newImplementation New contract implementation address
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
