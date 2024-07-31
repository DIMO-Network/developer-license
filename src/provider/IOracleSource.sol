// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IOracleSource {
    function updatePrice() external;
    function isUpdatable() external view returns (bool updatable);

    function getAmountUsdPerToken() external returns (uint256 amountUsdPerToken, uint256 updateTimestamp);
    function getAmountUsdPerToken(bytes calldata data)
        external
        returns (uint256 amountUsdPerToken, uint256 updateTimestamp);

    function getAmountNativePerToken() external returns (uint256 amountNativePerToken, uint256 updateTimestamp);
    function getAmountNativePerToken(bytes calldata data)
        external
        returns (uint256 amountNativePerToken, uint256 updateTimestamp);

    function _amountUsdPerToken() external view returns (uint256);
    function _updateTimestamp() external view returns (uint256);
}
