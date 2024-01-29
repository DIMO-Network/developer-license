// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IOracleSource} from "./IOracleSource.sol";

contract OracleSource {

    uint256 public _updateTimestamp;
    uint256 public _amountUsdPerToken;

    event NewPrice(
        address source,
        uint256 amountUsdPerToken,
        uint256 updateTimestamp
    );

    function _newPrice() internal {
        emit NewPrice(address(this), _amountUsdPerToken, _updateTimestamp);
    }

    function isUpdatable() external virtual pure returns (bool updatable) {
        updatable = false;
    }

    function updatePrice() external virtual {}

    function getAmountNativePerToken() external returns (uint256 amountNativePerToken, uint256 updateTimestamp) {}

    function getAmountNativePerToken(bytes calldata data) external returns (uint256 amountNativePerToken, uint256 updateTimestamp) {}

}