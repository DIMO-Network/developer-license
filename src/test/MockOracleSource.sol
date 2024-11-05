// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OracleSource} from "../provider/OracleSource.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract MockOracleSource is OracleSource, AccessControl {
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _amountUsdPerToken = 110262839782427950;
        _updateTimestamp = 1701349809;
    }

    function getAmountUsdPerToken() external view returns (uint256 amountUsdPerToken_, uint256 updateTimestamp_) {
        amountUsdPerToken_ = _amountUsdPerToken;
        updateTimestamp_ = _updateTimestamp;
    }

    function getAmountUsdPerToken(bytes calldata /*data*/ )
        external
        view
        returns (uint256, /*amountUsdPerToken*/ uint256 /*updateTimestamp*/ )
    {
        return this.getAmountUsdPerToken();
    }
}
