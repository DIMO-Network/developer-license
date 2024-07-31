// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IOracleSource} from "./IOracleSource.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title NormalizedPriceProvider
 * @custom:version 1.0.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 * @custom:contributor Allyson English (@aesdfghjkl666)
 *
 * @dev Normalize the format of different oracle sources into a common source.
 */
contract NormalizedPriceProvider is AccessControl {
    /*//////////////////////////////////////////////////////////////
                             Access Controls
    //////////////////////////////////////////////////////////////*/
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");
    bytes32 public constant PROVIDER_ADMIN_ROLE = keccak256("PROVIDER_ADMIN_ROLE");

    uint256 public _primaryIndex;
    IOracleSource[] public _oracleSources;

    event PrimaryOracleSourceSet(uint256 indexed index);
    event OracleSourceRemoved(address indexed source);
    event OracleSourceAdded(address indexed source);

    uint256 constant MAX_ORACLE_SOURCES = 12;

    error ZeroAddress();
    error InvalidIndex();
    error MaxOraclesReached();

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function addOracleSource(address source) external onlyRole(PROVIDER_ADMIN_ROLE) {
        if (source == address(0)) {
            revert ZeroAddress();
        }
        if (_oracleSources.length >= MAX_ORACLE_SOURCES) {
            revert MaxOraclesReached();
        }

        _oracleSources.push(IOracleSource(source));
        emit OracleSourceAdded(source);
    }

    function setPrimaryOracleSource(uint256 index) external onlyRole(PROVIDER_ADMIN_ROLE) {
        if (index >= _oracleSources.length) {
            revert InvalidIndex();
        }
        _primaryIndex = index;
        emit PrimaryOracleSourceSet(_primaryIndex);
    }

    /**
     * Remove the oracle source from the array by swapping it with
     * the last element and then popping from the array
     */
    function removeOracleSource(uint256 indexToRemove) external onlyRole(PROVIDER_ADMIN_ROLE) {
        if (indexToRemove >= _oracleSources.length || indexToRemove == _primaryIndex) {
            revert InvalidIndex();
        }

        emit OracleSourceRemoved(address(_oracleSources[indexToRemove]));

        _oracleSources[indexToRemove] = _oracleSources[_oracleSources.length - 1];
        _oracleSources.pop();
    }

    /**
     * This function costs us $LINK and costs the caller gas.
     */
    function updatePrice() external onlyRole(UPDATER_ROLE) {
        _oracleSources[_primaryIndex].updatePrice();
    }

    function getPrimaryOracleSource() external view returns (address primaryOracleSource) {
        primaryOracleSource = address(_oracleSources[_primaryIndex]);
    }

    function getAllOracleSources() external view returns (address[] memory) {
        address[] memory oracleSources = new address[](_oracleSources.length);
        for (uint256 i = 0; i < _oracleSources.length; i++) {
            oracleSources[i] = address(_oracleSources[i]);
        }
        return oracleSources;
    }

    function getAmountUsdPerToken() public returns (uint256 amountUsdPerToken, uint256 updateTimestamp) {
        (amountUsdPerToken, updateTimestamp) = this.getAmountUsdPerToken("");
    }

    function getAmountUsdPerToken(bytes calldata data)
        public
        returns (uint256 amountUsdPerToken, uint256 updateTimestamp)
    {
        (amountUsdPerToken, updateTimestamp) = _oracleSources[_primaryIndex].getAmountUsdPerToken(data);
    }

    function getLastAmountUsdPerToken()
        public
        view
        returns (uint256 lastAmountUsdPerToken, uint256 lastUpdateTimestamp)
    {
        (lastAmountUsdPerToken, lastUpdateTimestamp) =
            (_oracleSources[_primaryIndex]._amountUsdPerToken(), _oracleSources[_primaryIndex]._updateTimestamp());
    }

    function isUpdatable() external view returns (bool updatable) {
        updatable = _oracleSources[_primaryIndex].isUpdatable();
    }
}
