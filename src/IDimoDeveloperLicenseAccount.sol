// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDimoDeveloperLicenseAccount {
    function initialize(uint256 tokenId_, address license_) external;
    function isValidSignature(bytes32 hashValue, bytes memory signature) external view returns (bytes4);
}