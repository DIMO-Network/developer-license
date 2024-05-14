// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

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
 */
contract DevLicenseDimo is DevLicenseMeta {
    /*//////////////////////////////////////////////////////////////
                             Access Controls
    //////////////////////////////////////////////////////////////*/

    /// @notice Role identifier for addresses authorized to revoke licenses.
    bytes32 public constant REVOKER_ROLE = keccak256("REVOKER_ROLE");

    /*//////////////////////////////////////////////////////////////
                            Member Variables
    //////////////////////////////////////////////////////////////*/

    /// @notice The name of the token (license).
    string public name;
    /// @notice The symbol of the token (license).
    string public symbol;

    /*//////////////////////////////////////////////////////////////
                                Events
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when a redirect URI is enabled for a license.
    event RedirectUriEnabled(uint256 indexed tokenId, string uri);
    /// @notice Emitted when a redirect URI is disabled for a license.
    event RedirectUriDisabled(uint256 indexed tokenId, string uri);
    /// @notice Emitted when a license is issued to an owner and associated with a clientId.
    event Issued(uint256 indexed tokenId, address indexed owner, address indexed clientId);

    /*//////////////////////////////////////////////////////////////
                               Mappings
    //////////////////////////////////////////////////////////////*/

    /// @dev Tracks the enabled status of redirect URIs for each tokenId.
    mapping(uint256 => mapping(string => bool)) private _redirectUris;

    /**
     * @dev Sets initial values for `name` and `symbol`, and forwards constructor parameters to the DevLicenseMeta contract.
     */
    constructor(
        address receiver_,
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_,
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_
    )
        DevLicenseMeta(
            receiver_,
            licenseAccountFactory_,
            provider_,
            dimoTokenAddress_,
            dimoCreditAddress_,
            licenseCostInUsd_
        )
    {
        symbol = "DLX";
        name = "DIMO Developer License";
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
        enabled = _redirectUris[tokenId][uri];
    }

    /**
     * @notice Enables or disables a redirect URI for a license.
     * @dev Only callable by the license owner.
     * @param tokenId The ID of the license.
     * @param enabled True to enable the URI, false to disable it.
     * @param uri The redirect URI to modify.
     */
    function setRedirectUri(uint256 tokenId, bool enabled, string calldata uri) external onlyTokenOwner(tokenId) {
        if (enabled) {
            _redirectUris[tokenId][uri] = enabled;
            emit RedirectUriEnabled(tokenId, uri);
        } else {
            delete _redirectUris[tokenId][uri];
            emit RedirectUriDisabled(tokenId, uri);
        }
    }

    /*//////////////////////////////////////////////////////////////
                            License Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Issues a license in exchange for DIMO tokens.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the issued license.
     * @return clientId The ID of the client associated with the issued license.
     */
    function issueInDimo(bytes32 licenseAlias) external returns (uint256 tokenId, address clientId) {
        return issueInDimo(msg.sender, licenseAlias);
    }

    /**
     * @notice Issues a new license to a specified address in exchange for DIMO tokens.
     *         Transfers spent $DIMO to the receiver address.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDimo(address to, bytes32 licenseAlias) public returns (uint256 tokenId, address clientId) {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken();

        uint256 tokenTransferAmount = (_licenseCostInUsd1e18 / amountUsdPerToken) * 1 ether;

        _dimoToken.transferFrom(to, _receiver, tokenTransferAmount);

        return _issue(to, licenseAlias);
    }

    /**
     * @notice Issues a new license in exchange for DIMO Credits (DC).
     * @dev This function is a wrapper over `issueInDc(address to)` for the sender.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDc(bytes32 licenseAlias) external returns (uint256 tokenId, address clientId) {
        return issueInDc(msg.sender, licenseAlias);
    }

    /**
     * @notice Issues a new license to a specified address in exchange for DIMO Credits.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function issueInDc(address to, bytes32 licenseAlias) public returns (uint256 tokenId, address clientId) {
        uint256 dcTransferAmount = (_licenseCostInUsd1e18 / _dimoCredit.dimoCreditRate()) * 1 ether;
        _dimoCredit.burn(to, dcTransferAmount);

        return _issue(to, licenseAlias);
    }

    /**
     * @dev Internal function to handle the issuance of a new license.
     * @param to The address to receive the license.
     * @param licenseAlias The license alias to be set.
     * @return tokenId The ID of the newly issued license.
     * @return clientId The address of the license account holding the new license.
     */
    function _issue(address to, bytes32 licenseAlias) private returns (uint256 tokenId, address clientId) {
        tokenId = ++_counter;
        clientId = _licenseAccountFactory.create(tokenId);

        _tokenIdToClientId[tokenId] = clientId;
        _clientIdToTokenId[clientId] = tokenId;
        _ownerOf[tokenId] = to;

        emit Issued(tokenId, to, clientId);

        /// Calling it here to emit LicenseAliasSet after Issued event
        if (licenseAlias.length > 0) {
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
        require(_stakeLicense[tokenId] == 0, "DevLicenseDimo: resolve staked funds prior to revocation");

        address tokenOwner = _ownerOf[tokenId];
        delete _ownerOf[tokenId];

        address clientId = _tokenIdToClientId[tokenId];
        delete _tokenIdToClientId[tokenId];
        delete _tokenIdToAlias[tokenId];
        delete _clientIdToTokenId[clientId];

        emit Transfer(tokenOwner, address(0), tokenId);
    }
}
