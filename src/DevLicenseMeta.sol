// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {DevLicenseStake} from "./DevLicenseStake.sol";

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title DevLicenseMeta
 * @dev Extends DevLicenseStake to add metadata functionality, including image and description handling.
 */
contract DevLicenseMeta is Initializable, DevLicenseStake {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseMeta
    struct DevLicenseMetaStorage {
        string _imageToken;
        string _imageContract;
        string _descriptionToken;
        string _descriptionContract;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DevLicenseMeta")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DEV_LICENSE_META_STORAGE_LOCATION =
        0x528ba85f43aa21e96244176d4db284a510484bc2715e2bea8ee3cbf67d5fb800;

    function _getDevLicenseMetaStorage() internal pure returns (DevLicenseMetaStorage storage $) {
        assembly {
            $.slot := DEV_LICENSE_META_STORAGE_LOCATION
        }
    }

    /**
     * @dev Sets initial metadata for tokens and the contract itself.
     * @param image String of a SVG for contract and token URIS
     * @param description String with a description for contract and token URIs
     */
    function __DevLicenseMeta_init(string calldata image, string calldata description) internal onlyInitializing {
        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();

        $._imageToken = Base64.encode(bytes(image));
        $._imageContract = Base64.encode(bytes(image));

        $._descriptionToken = description;
        $._descriptionContract = description;
    }

    // TODO Documentation
    function imageToken() external view returns (string memory) {
        return _getDevLicenseMetaStorage()._imageToken;
    }

    // TODO Documentation
    function imageContract() external view returns (string memory) {
        return _getDevLicenseMetaStorage()._imageContract;
    }

    // TODO Documentation
    function descriptionToken() external view returns (string memory) {
        return _getDevLicenseMetaStorage()._descriptionToken;
    }

    // TODO Documentation
    function descriptionContract() external view returns (string memory) {
        return _getDevLicenseMetaStorage()._descriptionContract;
    }

    /*//////////////////////////////////////////////////////////////
                          Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Updates the token image.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param image_ New image data for the tokens.
     */
    function setImageToken(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._imageToken = Base64.encode(bytes(image_));
    }

    /**
     * @notice Updates the contract image.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param image_ New image data for the contract.
     */
    function setImageContract(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._imageContract = Base64.encode(bytes(image_));
    }

    /**
     * @notice Updates the token description.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param description_ New description for the tokens.
     */
    function setDescriptionToken(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._descriptionToken = description_;
    }

    /**
     * @notice Updates the contract description.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param description_ New description for the contract.
     */
    function setDescriptionContract(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._descriptionContract = description_;
    }

    /*//////////////////////////////////////////////////////////////
                            NFT Metadata
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Generates the contract URI for marketplace display.
     * @return string URI of the contract metadata.
     */
    function contractURI() external view returns (string memory) {
        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"DIMO Developer License",' '"description":',
                            $._descriptionContract,
                            "," '"image": "',
                            "data:image/svg+xml;base64,",
                            $._imageContract,
                            '",' '"external_link": "https://dimo.zone/",'
                            '"collaborators": ["0x0000000000000000000000000000000000000000"]}'
                        )
                    )
                )
            )
        );
    }

    /**
     * @notice Generates the token URI for a given token ID.
     * @dev Concatenates base data with the token-specific ID to create unique metadata for each token.
     * @param tokenId The ID of the token.
     * @return string URI of the token's metadata.
     */
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            string(abi.encodePacked("DIMO Developer License #", Strings.toString(tokenId))),
                            '", "description":"',
                            $._descriptionToken,
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            $._imageToken,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
