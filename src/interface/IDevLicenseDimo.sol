// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IDevLicenseDimo {
    function isSigner(uint256 tokenId, address account) external view returns (bool);
    function ownerOf(uint256 tokenId) external view returns (address);
}
