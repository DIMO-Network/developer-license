// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {Metadata} from "./metadata/Metadata.sol";
import {DevLicenseCore} from "./DevLicenseCore.sol";
import {DevLicenseLock} from "./DevLicenseLock.sol";

/** 
 * 
 */
contract DevLicenseDimo is DevLicenseLock, Metadata {

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    event RedirectUriEnabled(uint256 tokenId, string uri);
    event Issued(uint256 tokenId, address owner, address clientId);

    /*//////////////////////////////////////////////////////////////
                              Mappings
    //////////////////////////////////////////////////////////////*/
    mapping(uint256 => mapping(string => bool)) private _redirectUris;

    /* * */

    constructor(
        address laf_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_) 
    DevLicenseLock(
        laf_,
        provider_,
        dimoTokenAddress_, 
        dimoCreditAddress_,
        licenseCostInUsd_
    ) {
        symbol = "DLX";
        name = "DIMO Developer License";
    }

    /**
     * 
     */
    function enableRedirectUri(uint256 tokenId, string calldata uri) onlyTokenOwner(tokenId) external {
        _redirectUris[tokenId][uri] = true;
        emit RedirectUriEnabled(tokenId, uri);
    }


    /*//////////////////////////////////////////////////////////////
                            License Logic
    //////////////////////////////////////////////////////////////*/

    function issueInDimo() external returns (uint256 tokenId, address clientId) {
        return issueInDimo(msg.sender);
    }

    /**
     * @dev transfer spent $DIMO to the DimoCredit receiver, a GnosisSafe address
     */
    function issueInDimo(address to) public returns (uint256 tokenId, address clientId) {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = _licenseCostInUsd * amountUsdPerToken;
        _dimoToken.transferFrom(to, _dimoCredit.receiver(), tokenTransferAmount);

        return _issue(to);
    }

    function issueInDc() external returns (uint256 tokenId, address clientId) {
        return issueInDc(msg.sender);
    }

    /**
     * TODO: is this math correct? do we need to normalize it... 
     */
    function issueInDc(address to) public returns (uint256 tokenId, address clientId) {
        uint256 dcTransferAmount = _licenseCostInUsd * _dimoCredit.dimoCreditRate();
        _dimoCredit.burn(to, dcTransferAmount);

        return _issue(to);
    }

    //clientId == accountAddress
    function _issue(address to) private returns (uint256 tokenId, address clientId) {
        tokenId = ++_counter;
        clientId = _laf.create(tokenId);

        _tokenIdToClientId[tokenId] = clientId;
        _clientIdToTokenId[clientId] = tokenId;
        _ownerOf[tokenId] = to;

        emit Issued(tokenId, to, clientId);
        emit Locked(tokenId); ///@dev ERC5192
        emit Transfer(address(0), to, tokenId); ///@dev ERC721
    }

    /**
     */
    function burn(uint256 tokenId) internal virtual {
        address tokenOwner = _ownerOf[tokenId];
        address from = msg.sender;
        bool authenticated = from == owner() || 
                             from == tokenOwner ||
                             isSigner(tokenId, from);
        require(authenticated, INVALID_MSG_SENDER);
        
        delete _ownerOf[tokenId];
        
        address clientId = _tokenIdToClientId[tokenId];
        delete _tokenIdToClientId[tokenId];
        delete _clientIdToTokenId[clientId];

        emit Transfer(tokenOwner, address(0), tokenId); ///@dev ERC721
    }



}
