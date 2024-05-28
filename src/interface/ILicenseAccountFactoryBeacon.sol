// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface ILicenseAccountFactoryBeacon {
    function create(uint256 tokenId) external returns (address clone);
}
