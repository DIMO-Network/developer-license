// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";
import {IOracleSource} from "./interface/IOracleSource.sol";

/**
 * @notice Normalize the format of different oracle sources into a common source.
 */
contract NormalizedPriceProvider is Ownable2Step {

    mapping(address => bool) private _allowedAddress;

    uint256 public _primaryIndex;
    IOracleSource[] public _oracleSources;

    event PrimaryOracleSourceSet(uint256 indexed index);
    event OracleSourceRemoved(address indexed source);
    event OracleSourceAdded(address indexed source);

    uint256 constant MAX_ORACLE_SOURCES = 12;
    string constant private ERROR_INVALID_INDEX = "NormalizedPriceProvider: invalid index";
    string constant private ERROR_MAX_ORACLES_REACHED = "NormalizedPriceProvider: max oracle sources reached";

    constructor() Ownable(msg.sender) {
        _allowedAddress[msg.sender] = true;
    }

    modifier onlyAllowedAddress() {
        require(_allowedAddress[msg.sender], "NormalizedPriceProvider: invalid msg.senderd");
        _;
    }

    function addOracleSource(address source) onlyOwner external {
        require(source != address(0), "NormalizedPriceProvider: invalid source address");
        require(_oracleSources.length < MAX_ORACLE_SOURCES, ERROR_MAX_ORACLES_REACHED);
        _oracleSources.push(IOracleSource(source));
        emit OracleSourceAdded(source);
    }

    function setPrimaryOracleSource(uint256 index) onlyOwner external {
        require(index < _oracleSources.length, ERROR_INVALID_INDEX);
        _primaryIndex = index;
        emit PrimaryOracleSourceSet(_primaryIndex);
    }

    /**
     * Remove the oracle source from the array by swapping it with 
     * the last element and then popping from the array
     */
    function removeOracleSource(uint256 indexToRemove) onlyOwner external {
        require(indexToRemove < _oracleSources.length && 
                indexToRemove != _primaryIndex, ERROR_INVALID_INDEX);

        emit OracleSourceRemoved(address(_oracleSources[indexToRemove]));
        
        _oracleSources[indexToRemove] = _oracleSources[_oracleSources.length - 1];
        _oracleSources.pop();
    }

    /**
     * This shouldn't be permissioned, it'll cost us $LINK, but it'll cost
     * the caller gas.
     */
    function updatePrice() onlyAllowedAddress external {
        _oracleSources[_primaryIndex].updatePrice();
    }

    function getPrimaryOracleSource() external view returns (address primaryOracleSource) {
        primaryOracleSource = address(_oracleSources[_primaryIndex]);
    }

    function getAllOracleSources() external view returns (address[] memory) {
        address[] memory oracleSources = new address[](_oracleSources.length);
        for(uint256 i = 0; i < _oracleSources.length; i++) {
            oracleSources[i] = address(_oracleSources[i]);
        }
        return oracleSources;
    }

    function getAmountUsdPerToken() public returns (uint256 amountUsdPerToken, uint256 updateTimestamp) {
        (amountUsdPerToken, updateTimestamp) = this.getAmountUsdPerToken("");
    }

    function getAmountUsdPerToken(bytes calldata data) public returns (uint256 amountUsdPerToken, uint256 updateTimestamp) {
        (amountUsdPerToken, updateTimestamp) = _oracleSources[_primaryIndex].getAmountUsdPerToken(data);
    }

    function isUpdatable() external view returns (bool updatable) {
        updatable = _oracleSources[_primaryIndex].isUpdatable();
    }

    function setAllowedAddress(address addr, bool status) external onlyOwner {
        _allowedAddress[addr] = status;
    }

    function isAddressAllowed(address addr) external view returns (bool allowed) {
        allowed = _allowedAddress[addr];
    }

}
