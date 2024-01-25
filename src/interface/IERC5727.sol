// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC5192} from "./IERC5192.sol";
import {IERC5484} from "./IERC5484.sol";

/**
 * @title ERC5727 Soulbound Token Interface
 * @dev The core interface of the ERC5727 standard.
 */
interface IERC5727 is IERC5192, IERC5484 {
    /**
     * @dev MUST emit when a token is revoked.
     * @param from The address of the owner
     * @param tokenId The token id
     */
    event Revoked(address indexed from, uint256 indexed tokenId);

    /**
     * @dev MUST emit when a token is verified.
     * @param by The address that initiated the verification
     * @param tokenId The token id
     * @param result The result of the verification
     */
    event Verified(address indexed by, uint256 indexed tokenId, bool result);

    /**
     * @notice Get the verifier of a token.
     * @dev MUST revert if the `tokenId` does not exist
     * @param tokenId the token for which to query the verifier
     * @return The address of the verifier of `tokenId`
     */
    function verifierOf(uint256 tokenId) external view returns (address);

    /**
     * @notice Get the issuer of a token.
     * @dev MUST revert if the `tokenId` does not exist
     * @param tokenId the token for which to query the issuer
     * @return The address of the issuer of `tokenId`
     */
    function issuerOf(uint256 tokenId) external view returns (address);

    /**
     * @notice Issue credit to a token.
     * @dev MUST revert if the `tokenId` does not exist.
     * @param tokenId The token id
     * @param amount The amount of the credit
     * @param data The additional data used to issue the credit
     */
    function issue(
        uint256 tokenId,
        uint256 amount,
        bytes calldata data
    ) external payable;

    /**
     * @notice Revoke a token from an address.
     * @dev MUST revert if the `tokenId` does not exist.
     * @param tokenId The token id
     * @param data The additional data used to revoke the token
     */
    function revoke(uint256 tokenId, bytes calldata data) external payable;

    /**
     * @notice Verify if a token is valid.
     * @dev MUST revert if the `tokenId` does not exist.
     * @param tokenId The token id
     * @param data The additional data used to verify the token
     * @return A boolean indicating whether the token is successfully verified
     */
    function verify(
        uint256 tokenId,
        bytes calldata data
    ) external returns (bool);
}