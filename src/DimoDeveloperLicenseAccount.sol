// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";
import {IDimoDeveloperLicense} from "./interface/IDimoDeveloperLicense.sol";

//You can consider EOA signatures from the "owner" of the contract to be valid.
//You could store a list of approved messages and only consider those to be valid.
contract DimoDeveloperLicenseAccount is IERC1271 {
    IDimoDeveloperLicense private _license;
    uint256 private _tokenId;

    function initialize(uint256 tokenId_, address license_) public {
        _license = IDimoDeveloperLicense(license_);
        _tokenId = tokenId_;
    }

    function isValidSignature(bytes32 hashValue, bytes memory signature) external view returns (bytes4) {
        address recovered = ECDSA.recover(hashValue, signature);
        if (_license.isSigner(_tokenId, recovered)) {
            return IERC1271.isValidSignature.selector; //0x1626ba7e
        } else {
            return 0xffffffff;
        }
    }
}
