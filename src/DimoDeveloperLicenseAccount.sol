// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

interface IDimoDeveloperLicense {
    function isSigner(uint256 tokenId, address account) external view returns (bool);
}

contract DimoDeveloperLicenseAccount is IERC1271 {
    IDimoDeveloperLicense private dimoDeveloperLicense;
    uint256 private tokenId;

    constructor(uint256 tokenId_) {
        dimoDeveloperLicense = IDimoDeveloperLicense(msg.sender);
        tokenId = tokenId_;
    }

    function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4) {
        address recovered = ECDSA.recover(hash, signature);
        if (dimoDeveloperLicense.isSigner(tokenId, recovered)) {
            return IERC1271.isValidSignature.selector;
        } else {
            return 0xffffffff;
        }
    }
}
