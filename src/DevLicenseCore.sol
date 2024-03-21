// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console2} from "forge-std/Test.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
import {ILicenseAccountFactory} from "./interface/ILicenseAccountFactory.sol";
import {IDevLicenseDimo} from "./interface/IDevLicenseDimo.sol";
import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";

contract DevLicenseCore is IDevLicenseDimo, AccessControl {

    /*//////////////////////////////////////////////////////////////
                             Access Controls
    //////////////////////////////////////////////////////////////*/
    bytes32 public constant LICENSE_ADMIN_ROLE = keccak256("LICENSE_ADMIN_ROLE");

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    IDimoToken public _dimoToken; 
    //TODO: ^define in constructor 
    IDimoCredit public _dimoCredit;
    NormalizedPriceProvider public _provider;
    ILicenseAccountFactory public _licenseAccountFactory;
    uint256 public _periodValidity; ///@dev signer validity expiration
    uint256 public _licenseCostInUsd1e18;
    uint256 public _counter;

    /*//////////////////////////////////////////////////////////////
                              Mappings
    //////////////////////////////////////////////////////////////*/
    mapping(uint256 => address) public _ownerOf;
    mapping(uint256 => address) public _tokenIdToClientId;
    mapping(address => uint256) public _clientIdToTokenId;
    mapping(uint256 => mapping(address => uint256)) public _signers; ///@dev expiration determined by block.timestamp

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    event Locked(uint256 indexed tokenId);
    event UpdateLicenseCost(uint256 indexed licenseCost);
    event UpdatePeriodValidity(uint256 indexed periodValidity);
    event SignerEnabled(uint256 indexed tokenId, address indexed signer);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId); ///@dev on mint & burn

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_TOKEN_ID = "DevLicenseDimo: invalid tokenId";
    string INVALID_OPERATION = "DevLicenseDimo: invalid operation";
    string INVALID_MSG_SENDER = "DevLicenseDimo: invalid msg.sender";

    /*//////////////////////////////////////////////////////////////
                            Modifiers
    //////////////////////////////////////////////////////////////*/

    modifier onlyTokenOwner(uint256 tokenId) { 
        require(msg.sender == ownerOf(tokenId), INVALID_MSG_SENDER);
        _;
    }

    constructor(
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd1e18_) {

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        
        _periodValidity = 365 days;

        _dimoToken = IDimoToken(0xE261D618a959aFfFd53168Cd07D12E37B26761db);
        _dimoCredit = IDimoCredit(dimoCreditAddress_);
        _provider = NormalizedPriceProvider(provider_);
    
        _licenseAccountFactory = ILicenseAccountFactory(licenseAccountFactory_);
        _dimoToken = IDimoToken(dimoTokenAddress_);
        _licenseCostInUsd1e18 = licenseCostInUsd1e18_;
    }

    /*//////////////////////////////////////////////////////////////
                       Signer a.k.a. API Key
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice License can be minted by any EOA and assigned an owner, 
     * or by the owner directly. the owner then enables a key and/or set
     * of keys to act as a signer, to sign challenges from the backend 
     * to access API resources.
     */
    function enableSigner(uint256 tokenId, address signer) onlyTokenOwner(tokenId) external {
        _enableSigner(tokenId, signer);
    }

    function _enableSigner(uint256 tokenId, address signer) internal {
        _signers[tokenId][signer] = block.timestamp;
        emit SignerEnabled(tokenId, signer);
    }

    function isSigner(uint256 tokenId, address signer) public view returns (bool) {
        uint256 timestampInit = _signers[tokenId][signer];
        uint256 timestampCurrent = block.timestamp;
        if(timestampCurrent - timestampInit > _periodValidity) {
            return false;
        } else {
            return true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    function setLicenseCost(uint256 licenseCostInUsd1e18_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _licenseCostInUsd1e18 = licenseCostInUsd1e18_;
        emit UpdateLicenseCost(_licenseCostInUsd1e18);
    }

    function setPeriodValidity(uint256 periodValidity_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _periodValidity = periodValidity_;
        emit UpdatePeriodValidity(_periodValidity);
    }

    /*//////////////////////////////////////////////////////////////
                             NO-OP NFT Logic
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
                              NFT Logic
    //////////////////////////////////////////////////////////////*/

    function totalSupply() external view returns (uint256 totalSupply_) {
        totalSupply_ = _counter;
    } 

    function ownerOf(uint256 tokenId) public view virtual returns (address owner) {
        require((owner = _ownerOf[tokenId]) != address(0), INVALID_TOKEN_ID);
    }

    /*//////////////////////////////////////////////////////////////
                            SBT Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev ERC5192: Minimal Soulbound NFTs Minimal interface for 
     * soulbinding EIP-721 NFTs
     */
    function locked(uint256 tokenId) external view returns (bool locked_) {
        require(locked_ = _exists(tokenId), INVALID_TOKEN_ID);
    }

    /*//////////////////////////////////////////////////////////////
                         Private Helper Functions
    //////////////////////////////////////////////////////////////*/

    function _exists(uint256 tokenId) private view returns (bool) {
        return _ownerOf[tokenId] != address(0);
    }

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/
    
    function supportsInterface(bytes4 interfaceId) public override pure returns (bool) {
        return
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0xb45a3c0e || // ERC165 Interface ID for ERC5192
            interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }

}
