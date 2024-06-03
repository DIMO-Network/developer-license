// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

import {BeaconProxy} from "openzeppelin-contracts/contracts/proxy/beacon/BeaconProxy.sol";

import {IDevLicenseDimo} from "../interface/IDevLicenseDimo.sol";

// TODO Documentation / rename contract
/**
 * @title Dimo Developer License Account
 * @notice Represents an account holding a DIMO Developer License, capable of signature verification according to ERC1271.
 * @dev This contract implements the IERC1271 interface for signature verification, enabling it to act as a smart contract wallet.
 * It links a DIMO Developer License to off-chain actions by verifying if signatures are made by authorized signers of the license.
 */
contract DimoDeveloperLicenseAccount is IERC1271 {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseCore
    struct DimoDeveloperLicenseAccountStorage {
        /// Reference to the DIMO Developer License contract.
        IDevLicenseDimo _license;
        ///  Token ID of the DIMO Developer License associated with this account.
        uint256 _tokenId;
        ///  Ensures initialization can only occur once.
        bool _initialized;
    }

    // TODO change it after renaiming the contract
    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DimoDeveloperLicenseAccount")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant LICENSE_ACCOUNT_STORAGE_LOCATION =
        0xc61177ca523a3d53b92b866fe86addd26958bebb345f4646ebc7a249fbdd3000;

    function _getLicenseAccountStorage() internal pure returns (DimoDeveloperLicenseAccountStorage storage $) {
        assembly {
            $.slot := LICENSE_ACCOUNT_STORAGE_LOCATION
        }
    }

    error LicenseAccountAlreadyInitialized();
    error ZeroAddress();
    error InvalidTokenId(uint256 tokenId);

    /**
     * @notice Initializes the account with a specific token ID and license contract.
     * @dev This function is intended to be called once to set up the account.
     * @param tokenId_ The token ID of the associated DIMO Developer License.
     * @param license_ The address of the DIMO Developer License contract.
     */
    function initialize(uint256 tokenId_, address license_) external {
        DimoDeveloperLicenseAccountStorage storage $ = _getLicenseAccountStorage();

        if ($._initialized) {
            revert LicenseAccountAlreadyInitialized();
        }
        if (license_ == address(0)) {
            revert ZeroAddress();
        }
        if (tokenId_ == 0) {
            revert InvalidTokenId(tokenId_);
        }

        $._license = IDevLicenseDimo(license_);
        $._tokenId = tokenId_;
        $._initialized = true;
    }

    /**
     * @notice Returns the DevLicenseDimo address
     */
    function license() public view returns (address) {
        return address(_getLicenseAccountStorage()._license);
    }

    /**
     * @notice Returns the token ID associated with this contract
     */
    function tokenId() public view returns (uint256) {
        return _getLicenseAccountStorage()._tokenId;
    }

    /**
     * @notice Checks if an address is an authorized signer for the associated license.
     * @dev Useful for off-chain services to verify if actions are initiated by an authorized entity.
     * @param signer The address to check.
     * @return True if the address is an authorized signer, false otherwise.
     */
    function isSigner(address signer) external view returns (bool) {
        DimoDeveloperLicenseAccountStorage storage $ = _getLicenseAccountStorage();

        return $._license.isSigner($._tokenId, signer);
    }

    /**
     * @notice Verifies if a given signature is valid for a provided hash, according to ERC1271.
     * @param hashValue The hash of the data that was signed.
     * @param signature The signature to verify.
     * @return The magic value `0x1626ba7e` if the signature is valid; otherwise, `0xffffffff`.
     */
    function isValidSignature(bytes32 hashValue, bytes calldata signature) external view returns (bytes4) {
        DimoDeveloperLicenseAccountStorage storage $ = _getLicenseAccountStorage();

        address recovered = ECDSA.recover(hashValue, signature);
        if ($._license.isSigner($._tokenId, recovered)) {
            return IERC1271.isValidSignature.selector; //0x1626ba7e
        } else {
            return 0xffffffff;
        }
    }
}
