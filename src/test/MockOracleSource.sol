// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {OracleSource} from "../provider/OracleSource.sol";

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract MockOracleSource is OracleSource, AccessControl {
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function getAmountUsdPerToken() external pure returns (uint256 amountUsdPerToken_, uint256 updateTimestamp_) {
        amountUsdPerToken_ = 110262839782427950;
        updateTimestamp_ = 1701349809;
    }

    function getAmountUsdPerToken(bytes calldata /*data*/ )
        external
        view
        returns (uint256, /*amountUsdPerToken*/ uint256 /*updateTimestamp*/ )
    {
        return this.getAmountUsdPerToken();
    }
}
