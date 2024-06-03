// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.24;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";

import {DimoDeveloperLicenseAccount} from "./DimoDeveloperLicenseAccount.sol";
import {ILicenseAccountFactory} from "../interface/ILicenseAccountFactory.sol";

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
 * @dev Inherits from Ownable2Step for secure ownership transfer and implements ILicenseAccountFactory
 *      for creating license accounts.
 */
contract LicenseAccountFactory is Initializable, AccessControlUpgradeable, UUPSUpgradeable, ILicenseAccountFactory {
    /// @custom:storage-location erc7201:DIMOdevLicense.storage.DevLicenseCore
    struct LicenseAccountFactoryStorage {
        /// Address of the license account template for cloning.
        address _beaconProxyTemplate;
        /// Address of the DIMO Developer License contract.
        address _devLicenseDimo;
    }

    // keccak256(abi.encode(uint256(keccak256("DIMOdevLicense.storage.licenseAccountFactory")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant LICENSE_ACCOUNT_FACTORY_STORAGE_LOCATION =
        0x40ced5d11d7094d6db63c96a427d45c3995dd8ebd73e1f207257670ac2aca100;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    function _getLicenseAccountFactoryStorage() internal pure returns (LicenseAccountFactoryStorage storage $) {
        assembly {
            $.slot := LICENSE_ACCOUNT_FACTORY_STORAGE_LOCATION
        }
    }

    error ZeroAddress();
    error Unauthorized(address);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // TODO Documentation
    // /**
    //  * @dev Initializes the contract by creating a new DimoDeveloperLicenseAccount as a template
    //  *      for future clones and sets the owner of the contract.
    //  */
    function initialize(address beacon) external initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());

        LicenseAccountFactoryStorage storage $ = _getLicenseAccountFactoryStorage();

        if (beacon == address(0)) {
            revert ZeroAddress();
        }

        $._beaconProxyTemplate = address(new BeaconProxy(beacon, ""));
    }

    /**
     * @notice Returns the Beacon Proxy template address
     */
    function beaconProxyTemplate() public view returns (address) {
        return _getLicenseAccountFactoryStorage()._beaconProxyTemplate;
    }

    /**
     * @notice Returns the DevLicenseDimo address
     */
    function devLicenseDimo() public view returns (address) {
        return _getLicenseAccountFactoryStorage()._devLicenseDimo;
    }

    /**
     * @notice Sets the address of the DIMO Developer License contract.
     * @param devLicenseDimo_ The address of the DIMO Developer License contract.
     */
    function setDevLicenseDimo(address devLicenseDimo_) external onlyRole(ADMIN_ROLE) {
        LicenseAccountFactoryStorage storage $ = _getLicenseAccountFactoryStorage();

        if (devLicenseDimo_ == address(0)) {
            revert ZeroAddress();
        }

        $._devLicenseDimo = devLicenseDimo_;
    }

    /**
     * @notice Creates a new clone of the DimoDeveloperLicenseAccount, initializing it with a token ID and the license contract address.
     * @dev Only DevLicenseDimo can call this function
     * @param tokenId The token ID to associate with the newly created license account.
     * @return clone_ The address of the newly created clone account.
     */
    function create(uint256 tokenId) external returns (address clone_) {
        LicenseAccountFactoryStorage storage $ = _getLicenseAccountFactoryStorage();

        if (_msgSender() != $._devLicenseDimo) {
            revert Unauthorized(_msgSender());
        }

        clone_ = Clones.clone($._beaconProxyTemplate);
        DimoDeveloperLicenseAccount(clone_).initialize(tokenId, $._devLicenseDimo);
    }

    /**
     * @notice Internal function to authorize contract upgrade
     * @dev Caller must have the upgrader role
     * @param newImplementation New contract implementation address
     */
    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}
}
