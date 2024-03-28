// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {IDevLicenseDimo} from "./interface/IDevLicenseDimo.sol";

/**
 * @title Dimo Developer License Account
 * @notice Represents an account holding a DIMO Developer License, capable of signature verification according to ERC1271.
 * @dev This contract implements the IERC1271 interface for signature verification, enabling it to act as a smart contract wallet.
 * It links a DIMO Developer License to off-chain actions by verifying if signatures are made by authorized signers of the license.
 */
contract DimoDeveloperLicenseAccount is IERC1271 {

    /// @notice Reference to the DIMO Developer License contract.
    IDevLicenseDimo private _license;
    /// @notice Token ID of the DIMO Developer License associated with this account.
    uint256 private _tokenId;
    /// @notice Ensures initialization can only occur once.
    bool private _initialized;

    /**
     * @notice Initializes the account with a specific token ID and license contract.
     * @dev This function is intended to be called once to set up the account.
     * @param tokenId_ The token ID of the associated DIMO Developer License.
     * @param license_ The address of the DIMO Developer License contract.
     */
    function initialize(uint256 tokenId_, address license_) public {
        require(!_initialized, "DimoDeveloperLicenseAccount: invalid operation");
        _license = IDevLicenseDimo(license_);
        _tokenId = tokenId_;
        _initialized = true;
    }

    /**
     * @notice Checks if an address is an authorized signer for the associated license.
     * @dev Useful for off-chain services to verify if actions are initiated by an authorized entity.
     * @param signer The address to check.
     * @return True if the address is an authorized signer, false otherwise.
     */
    function isSigner(address signer) public view returns(bool) {
        return _license.isSigner(_tokenId, signer);
    }

    /**
     * @notice Verifies if a given signature is valid for a provided hash, according to ERC1271.
     * @param hashValue The hash of the data that was signed.
     * @param signature The signature to verify.
     * @return The magic value `0x1626ba7e` if the signature is valid; otherwise, `0xffffffff`.
     */
    function isValidSignature(bytes32 hashValue, bytes memory signature) external view returns (bytes4) {
        address recovered = ECDSA.recover(hashValue, signature);
        if (_license.isSigner(_tokenId, recovered)) {
            return IERC1271.isValidSignature.selector; //0x1626ba7e
        } else {
            return 0xffffffff;
        }
    }
}
