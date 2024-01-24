// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IDimoDeveloperLicense {
    function isSigner(uint256 tokenId, address account) external view returns (bool);
}