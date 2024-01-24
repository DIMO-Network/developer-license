// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";
import {ECDSA} from "openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

interface IDimoDeveloperLicense {
    function isSigner(uint256 tokenId, address account) external view returns (bool);
}
//You can consider EOA signatures from the "owner" of the contract to be valid.
//You could store a list of approved messages and only consider those to be valid.
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
            return IERC1271.isValidSignature.selector; //0x20c13b0b;
        } else {
            return 0xffffffff;
        }
    }
}
