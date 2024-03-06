// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import {DevLicenseLock} from "./DevLicenseLock.sol";

import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract DevLicenseMeta is DevLicenseLock {

    string public _imageToken;
    string public _imageContract;
    string public _descriptionToken;
    string public _descriptionContract;

    constructor(
        address licenseAccountFactory_,
        address provider_,
        address dimoTokenAddress_, 
        address dimoCreditAddress_,
        uint256 licenseCostInUsd_) 
    DevLicenseLock(
        licenseAccountFactory_,
        provider_,
        dimoTokenAddress_, 
        dimoCreditAddress_,
        licenseCostInUsd_
    ) {
        string memory image = '<svg width="432" height="432" viewBox="0 0 432 432" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="432" height="432" fill="#191919"/> <g clip-path="url(#clip0_136_16)"> <mask id="mask0_136_16" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="67" y="175" width="303" height="82"> <path d="M369.522 175H67.2031V256.302H369.522V175Z" fill="white"/> </mask> <g mask="url(#mask0_136_16)"> <path fill-rule="evenodd" clip-rule="evenodd" d="M312.882 253.294C317.848 255.322 323.172 256.344 328.54 256.3C333.908 256.353 339.236 255.337 344.206 253.313C349.178 251.289 353.694 248.297 357.491 244.512C361.289 240.728 364.29 236.226 366.323 231.271C368.353 226.316 369.374 221.007 369.321 215.655C369.374 210.302 368.355 204.992 366.325 200.036C364.292 195.08 361.291 190.578 357.495 186.792C353.696 183.007 349.18 180.015 344.208 177.99C339.236 175.966 333.91 174.95 328.54 175.002C323.172 174.959 317.85 175.98 312.882 178.007C307.916 180.035 303.402 183.027 299.607 186.81C295.813 190.593 292.81 195.09 290.775 200.041C288.741 204.992 287.714 210.298 287.756 215.648C287.714 220.998 288.739 226.304 290.771 231.256C292.806 236.208 295.809 240.706 299.605 244.49C303.4 248.274 307.913 251.267 312.882 253.294ZM358.983 215.648C358.983 232.923 345.871 246.552 328.54 246.552C311.316 246.552 298.204 232.931 298.204 215.648C298.204 198.364 311.316 184.744 328.54 184.744C345.871 184.744 358.983 198.372 358.983 215.648Z" fill="white"/> <path d="M267.107 254.558H277.708V192.316C277.702 188.016 275.984 183.894 272.934 180.854C269.885 177.813 265.75 176.102 261.436 176.097C258.349 176.105 255.327 176.985 252.721 178.635C250.115 180.285 248.031 182.637 246.712 185.419L221.547 238.81C221.086 239.779 220.36 240.599 219.451 241.174C218.543 241.749 217.49 242.055 216.414 242.059C215.669 242.059 214.931 241.913 214.243 241.629C213.556 241.345 212.93 240.928 212.404 240.404C211.878 239.878 211.46 239.256 211.174 238.57C210.89 237.884 210.744 237.149 210.744 236.406V197.578C210.738 191.882 208.465 186.422 204.425 182.395C200.385 178.367 194.907 176.102 189.194 176.097C183.482 176.104 178.006 178.37 173.967 182.397C169.929 186.424 167.657 191.883 167.652 197.578V254.55H178.253V197.578C178.256 194.685 179.41 191.913 181.461 189.867C183.512 187.821 186.293 186.669 189.194 186.663C192.096 186.667 194.879 187.818 196.932 189.864C198.984 191.91 200.139 194.684 200.143 197.578V236.406C200.146 240.707 201.862 244.83 204.912 247.871C207.964 250.912 212.099 252.622 216.414 252.626C219.501 252.619 222.523 251.739 225.129 250.089C227.735 248.439 229.819 246.086 231.138 243.304L256.303 189.913C256.764 188.944 257.491 188.125 258.399 187.55C259.308 186.975 260.36 186.668 261.436 186.663C262.939 186.665 264.381 187.261 265.444 188.321C266.506 189.381 267.105 190.817 267.107 192.316V254.558Z" fill="white"/> <path d="M143.109 176.133H153.383V254.565H143.109V176.133Z" fill="white"/> <path fill-rule="evenodd" clip-rule="evenodd" d="M132.105 215.345C132.105 192.916 114.374 176.133 90.2184 176.133H67.2031L67.2031 254.497H77.9191L90.2184 254.565C114.374 254.565 132.105 237.774 132.105 215.345ZM77.9191 185.744L90.2184 185.744C109.168 185.744 121.686 198.337 121.686 215.345C121.686 232.353 109.168 244.954 90.2184 244.954H77.9191V185.744Z" fill="white"/> </g> </g> <defs> <clipPath id="clip0_136_16"> <rect width="302.522" height="81.3022" fill="white" transform="translate(67 175)"/> </clipPath> </defs> </svg>';
        _imageToken = Base64.encode(bytes(image));
        _imageContract = Base64.encode(bytes(image));

        string memory description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        _descriptionToken = description;
        _descriptionContract = description;
    }

    /*//////////////////////////////////////////////////////////////
                          Admin Functions
    //////////////////////////////////////////////////////////////*/

    function setImageToken(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _imageToken = Base64.encode(bytes(image_));
    }

    function setImageContract(string calldata image_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _imageContract = Base64.encode(bytes(image_));
    }

    function setDescriptionToken(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _descriptionToken = description_;
    }

    function setDescriptionContract(string calldata description_) external onlyRole(LICENSE_ADMIN_ROLE) {
        _descriptionContract = description_;
    }

    /*//////////////////////////////////////////////////////////////
                            NFT Metadata
    //////////////////////////////////////////////////////////////*/

    function contractURI() external view returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"DIMO Developer License",'
                            '"description":', _descriptionContract, ','
                            '"image": "',
                            "data:image/svg+xml;base64,",
                            _imageContract,
                            '",' '"external_link": "https://dimo.zone/",'
                            '"seller_fee_basis_points": 0,'
                            '"fee_recipient": "0x0000000000000000000000000000000000000000"}'
                        )
                    )
                )
            )
        );
    }

    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            string(abi.encodePacked("DIMO Developer License #", Strings.toString(tokenId))),
                            '", "description":"',
                            _descriptionToken,
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            _imageToken,
                            '"}'
                        )
                    )
                )
            )
        );
    }

}