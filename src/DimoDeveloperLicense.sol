// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Base64} from "./Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {ILicenseAccountFactory} from "./interface/ILicenseAccountFactory.sol";
import {IDimoDeveloperLicense} from "./interface/IDimoDeveloperLicense.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "./interface/IDimoDeveloperLicenseAccount.sol";

contract DimoDeveloperLicense is Ownable2Step, IDimoDeveloperLicense {

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;
    string public _image;
    string public _description;
    uint256 public _licenseCost;
    uint256 public _counter;
    ILicenseAccountFactory public _laf;
    IDimoToken public _dimoToken;

    /*//////////////////////////////////////////////////////////////
                              Mappings
    //////////////////////////////////////////////////////////////*/
    mapping(uint256 => address) internal _ownerOf;
    mapping(uint256 tokenId => bool) private _revoked;
    mapping(uint256 => mapping(string => bool)) private redirectUris;
    mapping(uint256 => mapping(address => bool)) private signers;
    // TODO: do we use both of these?
    mapping(uint256 => string) _tokenIdToClientId;
    mapping(string => uint256) _clientIdToTokenId;

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_MSG_SENDER = "DimoDeveloperLicense: invalid msg.sender";
    string INVALID_OPERATION = "DimoDeveloperLicense: invalid operation";
    string INVALID_TOKEN_ID = "DimoDeveloperLicense: invalid tokenId";

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Revoked(address indexed from, uint256 indexed tokenId); ///@dev IERC5727
    event Issued(
        uint256 indexed tokenId, 
        address indexed owner, 
        address indexed account, 
        string clientId
    );
    event Verified(address indexed by, uint256 indexed tokenId, bool result);
    event Locked(uint256 tokenId);
    event UpdateLicenseCost(uint256 licenseCost);
    event RedirectUriEnabled(uint256 indexed tokenId, string uri);
    event SignerEnabled(uint256 indexed tokenId, address indexed signer);

    /*//////////////////////////////////////////////////////////////
                            Modifiers
    //////////////////////////////////////////////////////////////*/

    function ownerOf(uint256 tokenId) public view virtual returns (address owner) {
        require((owner = _ownerOf[tokenId]) != address(0), INVALID_TOKEN_ID);
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(msg.sender == ownerOf(tokenId), INVALID_MSG_SENDER);
        _;
    }

    constructor(
        address laf_,
        address dimoTokenAddress_, 
        uint256 licenseCost_) Ownable(msg.sender) {
        name = "DIMO Developer License";
        symbol = "DLX";

        _image = Base64.encode(bytes('<?xml version="1.0" encoding="UTF-8"?><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><path d="M0 2000 l0 -2000 2000 0 2000 0 0 2000 0 2000 -2000 0 -2000 0 0 -2000z m3353 428 c217 -104 307 -355 204 -571 -77 -163 -242 -258 -421 -244 -137 11 -249 75 -323 186 -59 86 -76 152 -71 265 5 113 42 200 115 274 97 97 194 134 335 128 75 -3 98 -9 161 -38z m-2595 17 c86 -20 156 -58 212 -114 162 -162 158 -430 -8 -582 -106 -97 -181 -119 -404 -119 l-158 0 0 415 0 415 148 0 c94 0 169 -6 210 -15z m572 -400 l0 -415 -55 0 -55 0 0 415 0 415 55 0 55 0 0 -415z m467 386 c46 -23 89 -70 110 -118 10 -24 13 -94 13 -273 0 -227 1 -241 20 -260 23 -23 49 -26 74 -7 9 7 80 145 156 307 86 183 150 307 169 327 62 64 169 67 235 5 55 -52 56 -61 56 -437 l0 -345 -55 0 -55 0 0 335 0 336 -25 25 c-24 24 -54 26 -77 5 -5 -4 -73 -144 -152 -311 -119 -252 -150 -310 -180 -334 -79 -64 -205 -37 -253 54 -22 41 -23 52 -23 279 0 167 -4 243 -13 260 -20 40 -64 66 -109 65 -35 -1 -48 -8 -75 -38 l-33 -36 0 -320 0 -320 -61 0 -60 0 3 328 3 327 28 51 c63 113 192 153 304 95z"/><path d="M3103 2360 c-94 -20 -180 -87 -224 -176 -20 -41 -24 -64 -24 -144 0 -89 2 -99 34 -158 59 -109 155 -165 281 -165 92 0 149 22 219 88 68 64 95 128 96 230 0 56 -6 95 -19 130 -25 64 -104 147 -164 173 -57 24 -142 34 -199 22z"/><path d="M520 2047 l0 -317 89 0 c121 0 203 26 269 85 147 132 129 381 -36 486 -62 39 -98 48 -219 56 l-103 6 0 -316z"/></svg>'));
        _description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        
        _laf = ILicenseAccountFactory(laf_);
        _dimoToken = IDimoToken(dimoTokenAddress_);
        _licenseCost = licenseCost_;
    }

    function setLicenseCost(uint256 licenseCost_) public onlyOwner {
        _licenseCost = licenseCost_;
        emit UpdateLicenseCost(licenseCost_);
    }

    function issue(string calldata clientId) external returns (uint256 tokenId, address accountAddress) {
        return issue(msg.sender, clientId);
    }

    function issue(address to, string calldata clientId) public returns (uint256 tokenId, address accountAddress) {
        require(_clientIdToTokenId[clientId] == 0, "DimoDeveloperLicense: invalid clientId");
        
        // TODO: token or DC...
        _dimoToken.transferFrom(to, address(this), _licenseCost);

        tokenId = ++_counter;
        _tokenIdToClientId[tokenId] = clientId;
        _clientIdToTokenId[clientId] = tokenId;

        _ownerOf[tokenId] = to; 

        accountAddress = _laf.create(tokenId);

        emit Issued(tokenId, to, accountAddress, clientId);
        emit Locked(tokenId); ///@dev IERC5192
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
        
        string memory clientId = _tokenIdToClientId[tokenId];
        delete _tokenIdToClientId[tokenId];
        delete _clientIdToTokenId[clientId];

        emit Revoked(from, tokenId); ///@dev IERC5727
        emit Transfer(tokenOwner, address(0), tokenId); ///@dev ERC721
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
    function isSigner(uint256 tokenId, address signer) public view returns (bool) {
        return signers[tokenId][signer];
    }

    /**
     * @dev Method signature aligns with paradigm established by IERC5727
     */
    function revoke(uint256 tokenId, bytes calldata /*data*/) external onlyOwner {
        _revoked[tokenId] = true;
        emit Revoked(msg.sender, tokenId);
    }

    /**
     * @dev Method signature aligns with paradigm established by IERC5727
     */
    function verify(uint256 tokenId, bytes calldata /*data*/) external returns (bool result) {
        result = _exists(tokenId) && !_revoked[tokenId];
        emit Verified(msg.sender, tokenId, result); 
    }

    /**
     * @dev Return value corresponds to BurnAuth.Both from IERC5484
     */
    function burnAuth(uint256 /*tokenId*/) external pure returns (uint8) {
        return 2;
    }

    /**
     * @dev IERC5192
     */
    function locked(uint256 tokenId) external view returns (bool) {
        require(_exists(tokenId), INVALID_TOKEN_ID);
        return true;
    }

    /**
     */
    function _exists(uint256 tokenId) private view returns (bool) {
        return keccak256(bytes(_tokenIdToClientId[tokenId])) != keccak256(bytes(""));
    }

    /*//////////////////////////////////////////////////////////////
                               SBT LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address /*spender*/, uint256 /*id*/) public virtual {
        revert(INVALID_OPERATION);
    }

    function setApprovalForAll(address /*operator*/, bool /*approved*/) public virtual {
        revert(INVALID_OPERATION);
    }

    function transferFrom(address /*from*/, address /*to*/, uint256 /*id*/) public virtual {
        revert(INVALID_OPERATION);
    }

    function safeTransferFrom(
        address /*from*/,
        address /*to*/,
        uint256 /*id*/
    ) public virtual {
        revert(INVALID_OPERATION);
    }

    function safeTransferFrom(
        address /*from*/,
        address /*to*/,
        uint256 /*id*/,
        bytes memory /*data*/
    ) public virtual {
        revert(INVALID_OPERATION);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }

    /*//////////////////////////////////////////////////////////////
                            NFT Metadata
    //////////////////////////////////////////////////////////////*/

    function contractURI() external view returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"DIMO Developer License",'
                            '"description":', _description, ','
                            '"image": "',
                            "data:image/svg+xml;base64,",
                            _image,
                            '",' '"external_link": "https://dimo.zone/",'
                            '"seller_fee_basis_points": 0,'
                            '"fee_recipient": "0x0000000000000000000000000000000000000000"}'
                        )
                    )
                )
            )
        );
    }

    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            string(abi.encodePacked("DIMO Developer License #", Strings.toString(tokenId))),
                            '", "description":"',
                            _description,
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            _image,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}