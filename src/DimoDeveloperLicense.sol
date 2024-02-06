// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {ILicenseAccountFactory} from "./interface/ILicenseAccountFactory.sol";
import {IDimoDeveloperLicense} from "./interface/IDimoDeveloperLicense.sol";
import {IDimoToken} from "./interface/IDimoToken.sol";
import {IDimoDeveloperLicenseAccount} from "./interface/IDimoDeveloperLicenseAccount.sol";

/* * */
import {console2} from "forge-std/Test.sol";
import {IDimoCredit} from "./interface/IDimoCredit.sol";
import {Metadata} from "./metadata/Metadata.sol";
import {NormalizedPriceProvider} from "./provider/NormalizedPriceProvider.sol";
/* * */

contract DimoDeveloperLicense is Ownable2Step, IDimoDeveloperLicense, Metadata {

    NormalizedPriceProvider _provider;

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;

    uint256 public _licenseCostInUsd;
    uint256 public _minimumStake;
    uint256 public _counter;
    ILicenseAccountFactory public _laf;
    
    IDimoToken public _dimoToken;
    IDimoCredit public _dimoCredit;

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

    /**
     * TODO: do we need the provider and the dc to be passed seperately, 
     * 'cause they have references to eachother...
     */
    constructor(
        address laf_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_) Ownable(msg.sender) {
        name = "DIMO Developer License";
        symbol = "DLX";

        _dimoCredit = IDimoCredit(dimoCreditAddress_);
        _provider = NormalizedPriceProvider(provider_);

        _laf = ILicenseAccountFactory(laf_);
        _dimoToken = IDimoToken(dimoTokenAddress_);
        _licenseCostInUsd = licenseCostInUsd_;
    }

    /*//////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////*/

    function setLicenseCost(uint256 licenseCostInUsd_) public onlyOwner {
        _licenseCostInUsd = licenseCostInUsd_;
        emit UpdateLicenseCost(_licenseCostInUsd);
    }

    /**
     * https://dimo.zone/news/on-dimo-tokenomics
     */
    //function setMinimumStake(uint256 minimumStake_) public onlyOwner {
        //_minimumStake = minimumStake_;
        //emit UpdateMinimumStake(minimumStake_);
    //}

    /*//////////////////////////////////////////////////////////////
                            License Logic
    //////////////////////////////////////////////////////////////*/

    function issueInDimo(string calldata clientId) external returns (uint256 tokenId, address accountAddress) {
        return issueInDimo(msg.sender, clientId);
    }

    /**
     * @dev transfer spent $DIMO to the DimoCredit receiver, a GnosisSafe address
     */
    function issueInDimo(address to, string calldata clientId) public returns (uint256 tokenId, address accountAddress) {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = amountUsdPerToken * _licenseCostInUsd;
        _dimoToken.transferFrom(to, _dimoCredit.receiver(), tokenTransferAmount);

        return _issue(to, clientId);
    }

    function issueInDc(string calldata clientId) external returns (uint256 tokenId, address accountAddress) {
        return issueInDc(msg.sender, clientId);
    }

    /**
     * TODO: is this math correct? do we need to normalize it... 
     */
    function issueInDc(address to, string calldata clientId) public returns (uint256 tokenId, address accountAddress) {
        uint256 dcTransferAmount = _licenseCostInUsd * _dimoCredit.dataCreditRate();
        _dimoCredit.burn(to, dcTransferAmount);

        return _issue(to, clientId);
    }

    function _issue(address to, string calldata clientId) private returns (uint256 tokenId, address accountAddress) {
        require(_clientIdToTokenId[clientId] == 0, "DimoDeveloperLicense: invalid clientId");

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

    /*//////////////////////////////////////////////////////////////
                            SBT Logic
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev method signature aligns with paradigm established by IERC5727
     * 
     * TODO: revoke vs. burn
     */
    function revoke(uint256 tokenId, bytes calldata /*data*/) external onlyOwner {
        _revoked[tokenId] = true;
        emit Revoked(msg.sender, tokenId);
    }

    /**
     * @dev method signature aligns with paradigm established by IERC5727
     */
    function verify(uint256 tokenId, bytes calldata /*data*/) external returns (bool result) {
        result = _exists(tokenId) && !_revoked[tokenId];
        emit Verified(msg.sender, tokenId, result); 
    }

    /**
     * @dev return value corresponds to BurnAuth.Both from IERC5484
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

    /*//////////////////////////////////////////////////////////////
                         Private Helper Functions
    //////////////////////////////////////////////////////////////*/
    function _exists(uint256 tokenId) private view returns (bool) {
        return keccak256(bytes(_tokenIdToClientId[tokenId])) != keccak256(bytes(""));
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
    } //^add these to DC

    /*//////////////////////////////////////////////////////////////
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }




}