// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

import {DimoDeveloperLicenseAccount} from "./DimoDeveloperLicenseAccount.sol";
import {ILicenseAccountFactoryBeacon} from "../interface/ILicenseAccountFactoryBeacon.sol";

// TODO Documentation
/**
 * @title DIMO Developer License Account Factory
 * @custom:version 1.0.0
 * @author Sean Matt English (@smatthewenglish)
 * @custom:coauthor Lorran Sutter (@LorranSutter)
 * @custom:coauthor Dylan Moreland (@elffjs)
 * @custom:coauthor Yevgeny Khessin (@zer0stars)
 * @custom:coauthor Rob Solomon (@robmsolomon)
 * @custom:contributor Allyson English (@aesdfghjkl666)
 * @notice Manages the creation of DIMO Developer License Account instances, enabling the deployment
 *         of minimal proxy contracts for each new license account. This factory pattern minimizes the
 *         gas cost for deploying many instances of license accounts by using EIP-1167 clone contracts.
 * @dev Inherits from Ownable2Step for secure ownership transfer and implements ILicenseAccountFactoryBeacon
 *      for creating license accounts.
 */
contract LicenseAccountFactoryBeacon is
    Initializable,
    AccessControlUpgradeable,
    UUPSUpgradeable,
    ILicenseAccountFactoryBeacon
{
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseCore
    struct LicenseAccountFactoryBeaconStorage {
        /// Address of the license account template for cloning.
        address _template;
        /// Address of the DIMO Developer License contract.
        address _license;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.licenseAccountFactoryBeacon")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant LICENSE_ACCOUNT_FACTORY_STORAGE_LOCATION =
        0x5e1322745c19eaa8cd721a083b70b7a25c7f1bd2e85931d5ffc5de61c84d3600;

    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    function _getLicenseAccountFactoryStorage() internal pure returns (LicenseAccountFactoryBeaconStorage storage $) {
        assembly {
            $.slot := LICENSE_ACCOUNT_FACTORY_STORAGE_LOCATION
        }
    }

    error ZeroAddress();

    // /**
    //  * @dev Initializes the contract by creating a new DimoDeveloperLicenseAccount as a template
    //  *      for future clones and sets the owner of the contract.
    //  */
    // constructor(address beacon, address license) Ownable(msg.sender) {
    //     _template = address(new BeaconProxy(beacon, ""));
    //     _license = license;
    // }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // TODO Documentation
    function initialize(address beacon, address license) external initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        LicenseAccountFactoryBeaconStorage storage $ = _getLicenseAccountFactoryStorage();

        if (beacon == address(0)) {
            revert ZeroAddress();
        }
        if (license == address(0)) {
            revert ZeroAddress();
        }

        $._template = address(new BeaconProxy(beacon, ""));
        $._license = license;
    }

    /**
     * @notice Creates a new clone of the DimoDeveloperLicenseAccount, initializing it with a token ID and the license contract address.
     * @param tokenId The token ID to associate with the newly created license account.
     * @return clone_ The address of the newly created clone account.
     */
    function create(uint256 tokenId) external returns (address clone_) {
        LicenseAccountFactoryBeaconStorage storage $ = _getLicenseAccountFactoryStorage();

        clone_ = Clones.clone($._template);
        DimoDeveloperLicenseAccount(clone_).initialize(tokenId, $._license);
    }

    /**
     * @notice Internal function to authorize contract upgrade
     * @dev Caller must have the upgrader role
     * @param newImplementation New contract implementation address
     */
    function _authorizeUpgrade(address newImplementation) internal virtual override onlyRole(UPGRADER_ROLE) {}
}
