// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {DevLicenseStake} from "./DevLicenseStake.sol";

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title DevLicenseMeta
 * @dev Extends DevLicenseStake to add metadata functionality, including image and description handling.
 * @dev To facilitate potential upgrades, this contract employs the Namespaced Storage Layout (https://eips.ethereum.org/EIPS/eip-7201)
 */
contract DevLicenseMeta is Initializable, DevLicenseStake {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseMeta
    struct DevLicenseMetaStorage {
        string _tokenImage;
        string _contractImage;
        string _tokenDescription;
        string _contractDescription;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.DevLicenseMeta")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant DEV_LICENSE_META_STORAGE_LOCATION =
        0x528ba85f43aa21e96244176d4db284a510484bc2715e2bea8ee3cbf67d5fb800;

    function _getDevLicenseMetaStorage() internal pure returns (DevLicenseMetaStorage storage $) {
        assembly {
            $.slot := DEV_LICENSE_META_STORAGE_LOCATION
        }
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Sets initial metadata for tokens and the contract itself.
     * @param image String of a SVG for contract and token URIs
     * @param description String with a description for contract and token URIs
     */
    function __DevLicenseMeta_init(string calldata image, string calldata description) internal onlyInitializing {
        __DevLicenseStake_init();

        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();

        $._tokenImage = Base64.encode(bytes(image));
        $._contractImage = Base64.encode(bytes(image));

        $._tokenDescription = description;
        $._contractDescription = description;
    }

    /**
     * @notice Returns the image token
     */
    function tokenImage() external view returns (string memory tokenImage_) {
        tokenImage_ = _getDevLicenseMetaStorage()._tokenImage;
    }

    /**
     * @notice Returns the image contract
     */
    function contractImage() external view returns (string memory contractImage_) {
        contractImage_ = _getDevLicenseMetaStorage()._contractImage;
    }

    /**
     * @notice Returns the token description
     */
    function tokenDescription() external view returns (string memory tokenDescription_) {
        tokenDescription_ = _getDevLicenseMetaStorage()._tokenDescription;
    }

    /**
     * @notice Returns the contract description
     */
    function contractDescription() external view returns (string memory contractDescription_) {
        contractDescription_ = _getDevLicenseMetaStorage()._contractDescription;
    }

    /*//////////////////////////////////////////////////////////////
                          Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Updates the token image.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param image_ New image data for the tokens.
     */
    function setTokenImage(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._tokenImage = Base64.encode(bytes(image_));
    }

    /**
     * @notice Updates the contract image.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param image_ New image data for the contract.
     */
    function setContractImage(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._contractImage = Base64.encode(bytes(image_));
    }

    /**
     * @notice Updates the token description.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param description_ New description for the tokens.
     */
    function setTokenDescription(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._tokenDescription = description_;
    }

    /**
     * @notice Updates the contract description.
     * @dev Only accessible by accounts with the LICENSE_ADMIN_ROLE.
     * @param description_ New description for the contract.
     */
    function setContractDescription(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _getDevLicenseMetaStorage()._contractDescription = description_;
    }

    /*//////////////////////////////////////////////////////////////
                            NFT Metadata
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Generates the contract URI for marketplace display.
     * @return contractURI_ URI of the contract metadata.
     */
    function contractURI() external view returns (string memory contractURI_) {
        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();
        contractURI_ = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"DIMO Developer License",' '"description":',
                            $._contractDescription,
                            "," '"image": "',
                            "data:image/svg+xml;base64,",
                            $._contractImage,
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
     * @return tokenURI_ URI of the token's metadata.
     */
    function tokenURI(uint256 tokenId) public view virtual returns (string memory tokenURI_) {
        DevLicenseMetaStorage storage $ = _getDevLicenseMetaStorage();
        tokenURI_ = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            string(abi.encodePacked("DIMO Developer License #", Strings.toString(tokenId))),
                            '", "description":"',
                            $._tokenDescription,
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            $._tokenImage,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
