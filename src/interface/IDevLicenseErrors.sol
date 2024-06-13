// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @dev Dev License contracts errors
 */
interface IDevLicenseErrors {
    error InvalidOperation();
    error InvalidSender(address sender);
    error NonexistentToken(uint256 tokenId);
    error AliasAlreadyInUse(bytes32 licenseAlias);
    error InvalidAmount(uint256 amount);
    error FrozenToken(uint256 tokenId);
    error InsufficientStakedFunds(uint256 tokenId, uint256 amount);
    error StakedFunds(uint256 tokenId);
}
