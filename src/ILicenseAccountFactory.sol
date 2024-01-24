// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ILicenseAccountFactory {
    function create(uint256 tokenId, address license_) external returns (address clone);
}