// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface ILicenseAccountFactory {
    function setLicense(address license) external;
    function create(uint256 tokenId) external returns (address clone);
}