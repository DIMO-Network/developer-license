// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {ILicenseAccountFactory} from "./interface/ILicenseAccountFactory.sol";
import {IDimoDeveloperLicense} from "./interface/IDimoDeveloperLicense.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "./interface/IDimoDeveloperLicenseAccount.sol";
import {IERC5727} from "./interface/IERC5727.sol";

contract DimoDeveloperLicense is ERC721, IERC5727, Ownable2Step, IDimoDeveloperLicense {

    //event Revoked(address indexed from, uint256 indexed tokenId);
    //event Verified(address indexed by, uint256 indexed tokenId, bool result);
    //event Issued (
    //     address indexed from,
    //     address indexed to,
    //     uint256 indexed tokenId,
    //     BurnAuth burnAuth
    //);
    //event Locked(uint256 tokenId);
    //event Unlocked(uint256 tokenId);

    ILicenseAccountFactory public _laf;

    uint256 public _licenseCost;
    uint256 private counter;
    IDimoToken private _dimoToken;

    event UpdateLicenseCost(uint256 licenseCost);
    event LicenseMinted(uint256 indexed tokenId, address indexed owner, address indexed account, string clientId);
    event RedirectUriEnabled(uint256 indexed tokenId, string uri);
    event SignerEnabled(uint256 indexed tokenId, address indexed signer);

    error ClientIdTaken();

    mapping(uint256 => address) private accounts;
    mapping(uint256 => mapping(string => bool)) private redirectUris;
    mapping(uint256 => mapping(address => bool)) private signers;

    mapping(uint256 => string) tokenIdToClientId;
    mapping(string => uint256) clientIdToTokenId;

    modifier onlyTokenOwner(uint256 tokenId) {
        require(msg.sender == ownerOf(tokenId), "DimoDeveloperLicense: invalid msg.sender");
        _;
    }

    constructor(
        address laf_,
        address dimoTokenAddress, 
        uint256 licenseCost_) ERC721("DIMO Developer License", "DDL") Ownable(msg.sender) {
        
        _laf = ILicenseAccountFactory(laf_);
        _dimoToken = IDimoToken(dimoTokenAddress);
        _licenseCost = licenseCost_;
    }

    function setLicenseCost(uint256 licenseCost_) public onlyOwner {
        _licenseCost = licenseCost_;
        emit UpdateLicenseCost(licenseCost_);
    }

    function mint(string calldata clientId) public returns (uint256 tokenId, address accountAddress) {
        if (clientIdToTokenId[clientId] != 0) {
            revert ClientIdTaken();
        }

        _dimoToken.transferFrom(msg.sender, address(this), _licenseCost);

        tokenId = ++counter;
        tokenIdToClientId[tokenId] = clientId;
        clientIdToTokenId[clientId] = tokenId;
        _mint(msg.sender, tokenId);

        accountAddress = _laf.create(tokenId);

        emit LicenseMinted(tokenId, msg.sender, accountAddress, clientId);
    }

    /**
     * TODO: why is the token owner able to set this? 
     */
    function enableRedirectUri(uint256 tokenId, string calldata uri) onlyTokenOwner(tokenId) external {
        redirectUris[tokenId][uri] = true;
        emit RedirectUriEnabled(tokenId, uri);
    }

    /**
     */
    function enableSigner(uint256 tokenId, address signer) onlyTokenOwner(tokenId) external {
        signers[tokenId][signer] = true;
        emit SignerEnabled(tokenId, signer);
    }

    /**
     */
    function isSigner(uint256 tokenId, address signer) external view returns (bool) {
        return signers[tokenId][signer];
    }

    function verifierOf(uint256 tokenId) external view returns (address) {}

    function issuerOf(uint256 tokenId) external view returns (address) {}
    
    function issue(
        address to,
        uint256 tokenId,
        uint256 slot,
        BurnAuth burnAuth,
        address verifier,
        bytes calldata data
    ) external payable {}

    function issue(
        uint256 tokenId,
        uint256 amount,
        bytes calldata data
    ) external payable {}

    function revoke(uint256 tokenId, bytes calldata data) external payable {}

    function revoke(
        uint256 tokenId,
        uint256 amount,
        bytes calldata data
    ) external payable {}

    function verify(
        uint256 tokenId,
        bytes calldata data
    ) external returns (bool) {}

    function burnAuth(uint256 tokenId) external view returns (BurnAuth) {}

    function locked(uint256 tokenId) external view returns (bool) {}
}