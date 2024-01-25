// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
// import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
// import {ERC721} from "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
// import {DimoDeveloperLicenseAccount} from "../DimoDeveloperLicenseAccount.sol";

// interface IDimoToken {
//     function transferFrom(address from, address to, uint256 value) external returns (bool);
// }

// //POAP
// //https://vitalik.eth.limo/general/2022/01/26/soulbound.html
// //https://eips.ethereum.org/EIPS/eip-5192
// /**
//  */
// contract DimoDeveloperLicense is ERC721, Ownable2Step {

//     /// Event emitted when a token `tokenId` is minted for `owner`
//     //event Minted(address owner, uint256 tokenId);
//     /// Event emitted when token `tokenId` of `owner` is revoked
//     //event Revoked(address owner, uint256 tokenId);

//     modifier onlyTokenOwner(uint256 tokenId) {
//         require(msg.sender == ownerOf(tokenId), "DimoDeveloperLicense: invalid msg.sender");
//         _;
//     }

//     uint256 public _licenseCost;
//     uint256 private counter;
//     IDimoToken private _dimoToken; //TODO: 'cause of the proxy won't this address always be the same?

//     event UpdateLicenseCost(uint256 licenseCost);
//     event LicenseMinted(uint256 indexed tokenId, address indexed owner, address indexed account, string clientId);
//     event RedirectUriEnabled(uint256 indexed tokenId, string uri);
//     event SignerEnabled(uint256 indexed tokenId, address indexed signer);

//     error ClientIdTaken();

//     mapping(uint256 => address) private accounts;
//     mapping(uint256 => mapping(string => bool)) private redirectUris;
//     mapping(uint256 => mapping(address => bool)) private signers;

//     mapping(uint256 => string) tokenIdToClientId;
//     mapping(string => uint256) clientIdToTokenId;

//     constructor(address dimoTokenAddress_, uint256 licenseCost_) ERC721("DIMO Developer License", "DDL") Ownable(msg.sender) {
//         _dimoToken = IDimoToken(dimoTokenAddress_);
//         _licenseCost = licenseCost_;
//     }

//     function mint(string calldata clientId) public returns (uint256, address) {
//         if (clientIdToTokenId[clientId] != 0) {
//             revert ClientIdTaken();
//         }

//         _dimoToken.transferFrom(msg.sender, address(this), _licenseCost);

//         uint256 tokenId = ++counter;
//         tokenIdToClientId[tokenId] = clientId;
//         clientIdToTokenId[clientId] = tokenId;
//         _mint(msg.sender, tokenId);

//         DimoDeveloperLicenseAccount account = new DimoDeveloperLicenseAccount(tokenId);
//         address accountAddress = address(account);

//         emit LicenseMinted(tokenId, msg.sender, accountAddress, clientId);

//         return (tokenId, accountAddress);
//     }

//     function enableRedirectUri(uint256 tokenId, string calldata uri) public onlyTokenOwner(tokenId) {
//         redirectUris[tokenId][uri] = true;
//         emit RedirectUriEnabled(tokenId, uri);
//     }

//     function enableSigner(uint256 tokenId, address signer) public onlyTokenOwner(tokenId) {
//         signers[tokenId][signer] = true;
//         emit SignerEnabled(tokenId, signer);
//     }

//     function isSigner(uint256 tokenId, address signer) public view returns (bool) {
//         return signers[tokenId][signer];
//     }

//     /**
//      * @dev Sets a new cost for the DIMO developer license.
//      * Can only be called by the contract owner.
//      *
//      * Emits an {UpdateLicenseCost} event indicating the updated license cost.
//      *
//      * Requirements:
//      * - The caller must be the contract owner.
//      *
//      * @param licenseCost_ The new cost of the license in DIMO tokens.
//      */
//     function setLicenseCost(uint256 licenseCost_) public onlyOwner {
//         _licenseCost = licenseCost_;
//         emit UpdateLicenseCost(licenseCost_);
//     }

//     function transferFrom(address from, address to, uint256 tokenId) public virtual {

//         revert ERC721InvalidReceiver(address(0));

//     }

//     // /**
//     //  * @dev See {IERC721-safeTransferFrom}.
//     //  */
//     // function safeTransferFrom(address from, address to, uint256 tokenId) public {
//     //     safeTransferFrom(from, to, tokenId, "");
//     // }

//     // /**
//     //  * @dev See {IERC721-safeTransferFrom}.
//     //  */
//     // function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual {
//     //     transferFrom(from, to, tokenId);
//     //     _checkOnERC721Received(from, to, tokenId, data);
//     // }

//     function burn(uint256 tokenId) external {
//         require(ownerOf(tokenId) == msg.sender, "Only the owner of the token can burn it.");
//         _burn(tokenId);
//     }

//     function _burn(uint256 tokenId) internal override(ERC721) {
//         super._burn(tokenId);
//     }

//     //supportsInterface(){}
// }
