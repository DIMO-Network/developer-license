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

    uint256 _periodValidity; ///@dev signer validity expiration

    /*//////////////////////////////////////////////////////////////
                              Member Variables
    //////////////////////////////////////////////////////////////*/
    string public name;
    string public symbol;

    uint256 public _licenseCostOffsetDc;  ///@dev variable pricing for cost in DC
    uint256 public _licenseCostOffsetDimo;///@dev variable pricing for cost in $DIMO
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
    mapping(uint256 => mapping(address => uint256)) private signers; ///@dev points to block.timestamp


    event Deposit(uint256 indexed tokenId, address indexed user, uint256 amount);
    event Withdraw(uint256 indexed tokenId, address indexed user, uint256 amount);

    /* * */

    mapping(uint256 => mapping(address => uint256)) private _licenseLockUp;

    function deposit(uint256 tokenId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");

        //require that they're a validSigner...

        _licenseLockUp[tokenId][msg.sender] += amount;

        emit Deposit(tokenId, msg.sender, amount);
    }

    function withdraw(uint256 tokenId, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(_licenseLockUp[tokenId][msg.sender] >= amount, "Insufficient balance to withdraw");

        _licenseLockUp[tokenId][msg.sender] -= amount;

        emit Withdraw(tokenId, msg.sender, amount);
    }

    function balanceOf(uint256 tokenId, address user) public view returns (uint256) {
        return _licenseLockUp[tokenId][user];
    }

    /* * */


    
    mapping(uint256 => address) _tokenIdToClientId;
    mapping(address => uint256) _clientIdToTokenId;

    /*//////////////////////////////////////////////////////////////
                            Error Messages
    //////////////////////////////////////////////////////////////*/
    string INVALID_MSG_SENDER = "DimoDeveloperLicense: invalid msg.sender";
    string INVALID_OPERATION = "DimoDeveloperLicense: invalid operation";
    string INVALID_TOKEN_ID = "DimoDeveloperLicense: invalid tokenId";

    /*//////////////////////////////////////////////////////////////
                            Events
    //////////////////////////////////////////////////////////////*/
    //TODO: what here needs to be indexed...
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Revoked(address indexed from, uint256 indexed tokenId); ///@dev IERC5727
    event Issued(
        uint256 indexed tokenId, 
        address indexed owner, 
        address indexed account, 
        address clientId
    );
    event Verified(address indexed by, uint256 indexed tokenId, bool result);
    event Locked(uint256 tokenId);
    event UpdateLicenseCost(uint256 licenseCost);
    event UpdatePeriodValidity(uint256 periodValidity);
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

        _periodValidity = 365 days;

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

    function setPeriodValidity(uint256 periodValidity_) public onlyOwner {
        _periodValidity = periodValidity_;
        emit UpdatePeriodValidity(_licenseCostInUsd);
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

    function issueInDimo() external returns (uint256 tokenId, address clientId) {
        return issueInDimo(msg.sender);
    }

    /**
     * @dev transfer spent $DIMO to the DimoCredit receiver, a GnosisSafe address
     */
    function issueInDimo(address to) public returns (uint256 tokenId, address clientId) {
        (uint256 amountUsdPerToken,) = _provider.getAmountUsdPerToken();
        uint256 tokenTransferAmount = amountUsdPerToken * _licenseCostInUsd;
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
        uint256 dcTransferAmount = _licenseCostInUsd * _dimoCredit.dataCreditRate();
        _dimoCredit.burn(to, dcTransferAmount);

        return _issue(to);
    }

    //clientId == accountAddress
    function _issue(address to) private returns (uint256 tokenId, address clientId) {
        //require(_clientIdToTokenId[clientId] == 0, "DimoDeveloperLicense: invalid clientId");

        tokenId = ++_counter;
        clientId = _laf.create(tokenId);
        
        _tokenIdToClientId[tokenId] = clientId;
        _clientIdToTokenId[clientId] = tokenId;

        _ownerOf[tokenId] = to; 

        emit Issued(tokenId, to, clientId, clientId);
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
        
        address clientId = _tokenIdToClientId[tokenId];
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
     * @notice validity period...
     */
    function enableSigner(uint256 tokenId, address signer) onlyTokenOwner(tokenId) external {
        signers[tokenId][signer] = block.timestamp;
        emit SignerEnabled(tokenId, signer);
    }

    /**
     */
    function isSigner(uint256 tokenId, address signer) public view returns (bool) {
        uint256 timestampInit = signers[tokenId][signer];
        uint256 timestampCurrent = block.timestamp;
        if(timestampCurrent - timestampInit > _periodValidity) {
            return false;
        } else {
            return true;
        }
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
        //TODO: _test_ these supportive functuions
        return _tokenIdToClientId[tokenId] != address(0);
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
                              ERC165 LOGIC
    //////////////////////////////////////////////////////////////*/
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return
            interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f;   // ERC165 Interface ID for ERC721Metadata
    }

}