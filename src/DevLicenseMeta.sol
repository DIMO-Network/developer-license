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
        _imageToken = Base64.encode(bytes('<svg width="432" height="432" viewBox="0 0 432 432" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="432" height="432" fill="#191919"/> <g clip-path="url(#clip0_136_16)"> <mask id="mask0_136_16" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="67" y="175" width="303" height="82"> <path d="M369.522 175H67.2031V256.302H369.522V175Z" fill="white"/> </mask> <g mask="url(#mask0_136_16)"> <path fill-rule="evenodd" clip-rule="evenodd" d="M312.882 253.294C317.848 255.322 323.172 256.344 328.54 256.3C333.908 256.353 339.236 255.337 344.206 253.313C349.178 251.289 353.694 248.297 357.491 244.512C361.289 240.728 364.29 236.226 366.323 231.271C368.353 226.316 369.374 221.007 369.321 215.655C369.374 210.302 368.355 204.992 366.325 200.036C364.292 195.08 361.291 190.578 357.495 186.792C353.696 183.007 349.18 180.015 344.208 177.99C339.236 175.966 333.91 174.95 328.54 175.002C323.172 174.959 317.85 175.98 312.882 178.007C307.916 180.035 303.402 183.027 299.607 186.81C295.813 190.593 292.81 195.09 290.775 200.041C288.741 204.992 287.714 210.298 287.756 215.648C287.714 220.998 288.739 226.304 290.771 231.256C292.806 236.208 295.809 240.706 299.605 244.49C303.4 248.274 307.913 251.267 312.882 253.294ZM358.983 215.648C358.983 232.923 345.871 246.552 328.54 246.552C311.316 246.552 298.204 232.931 298.204 215.648C298.204 198.364 311.316 184.744 328.54 184.744C345.871 184.744 358.983 198.372 358.983 215.648Z" fill="white"/> <path d="M267.107 254.558H277.708V192.316C277.702 188.016 275.984 183.894 272.934 180.854C269.885 177.813 265.75 176.102 261.436 176.097C258.349 176.105 255.327 176.985 252.721 178.635C250.115 180.285 248.031 182.637 246.712 185.419L221.547 238.81C221.086 239.779 220.36 240.599 219.451 241.174C218.543 241.749 217.49 242.055 216.414 242.059C215.669 242.059 214.931 241.913 214.243 241.629C213.556 241.345 212.93 240.928 212.404 240.404C211.878 239.878 211.46 239.256 211.174 238.57C210.89 237.884 210.744 237.149 210.744 236.406V197.578C210.738 191.882 208.465 186.422 204.425 182.395C200.385 178.367 194.907 176.102 189.194 176.097C183.482 176.104 178.006 178.37 173.967 182.397C169.929 186.424 167.657 191.883 167.652 197.578V254.55H178.253V197.578C178.256 194.685 179.41 191.913 181.461 189.867C183.512 187.821 186.293 186.669 189.194 186.663C192.096 186.667 194.879 187.818 196.932 189.864C198.984 191.91 200.139 194.684 200.143 197.578V236.406C200.146 240.707 201.862 244.83 204.912 247.871C207.964 250.912 212.099 252.622 216.414 252.626C219.501 252.619 222.523 251.739 225.129 250.089C227.735 248.439 229.819 246.086 231.138 243.304L256.303 189.913C256.764 188.944 257.491 188.125 258.399 187.55C259.308 186.975 260.36 186.668 261.436 186.663C262.939 186.665 264.381 187.261 265.444 188.321C266.506 189.381 267.105 190.817 267.107 192.316V254.558Z" fill="white"/> <path d="M143.109 176.133H153.383V254.565H143.109V176.133Z" fill="white"/> <path fill-rule="evenodd" clip-rule="evenodd" d="M132.105 215.345C132.105 192.916 114.374 176.133 90.2184 176.133H67.2031L67.2031 254.497H77.9191L90.2184 254.565C114.374 254.565 132.105 237.774 132.105 215.345ZM77.9191 185.744L90.2184 185.744C109.168 185.744 121.686 198.337 121.686 215.345C121.686 232.353 109.168 244.954 90.2184 244.954H77.9191V185.744Z" fill="white"/> </g> </g> <defs> <clipPath id="clip0_136_16"> <rect width="302.522" height="81.3022" fill="white" transform="translate(67 175)"/> </clipPath> </defs> </svg>'));
        _imageContract = Base64.encode(bytes('<svg width="432" height="432" viewBox="0 0 432 432" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="432" height="432" fill="white"/> <g clip-path="url(#clip0_136_6)"> <mask id="mask0_136_6" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="67" y="175" width="304" height="82"> <path d="M370.796 175H67V257H370.796V175Z" fill="white"/> </mask> <g mask="url(#mask0_136_6)"> <path fill-rule="evenodd" clip-rule="evenodd" d="M313.879 253.966C318.869 256.011 324.219 257.042 329.613 256.998C335.008 257.051 340.361 256.027 345.356 253.986C350.352 251.944 354.89 248.926 358.705 245.109C362.523 241.292 365.538 236.752 367.58 231.754C369.621 226.757 370.647 221.402 370.594 216.004C370.647 210.605 369.623 205.249 367.582 200.251C365.54 195.253 362.525 190.712 358.709 186.894C354.892 183.076 350.354 180.058 345.358 178.016C340.361 175.974 335.01 174.949 329.613 175.002C324.219 174.958 318.871 175.989 313.879 178.033C308.888 180.078 304.352 183.096 300.539 186.911C296.726 190.726 293.708 195.263 291.664 200.256C289.62 205.25 288.587 210.601 288.63 215.997C288.587 221.393 289.618 226.744 291.66 231.739C293.704 236.733 296.722 241.27 300.537 245.087C304.35 248.902 308.886 251.921 313.879 253.966ZM360.205 215.997C360.205 233.42 347.029 247.166 329.613 247.166C312.305 247.166 299.129 233.428 299.129 215.997C299.129 198.565 312.305 184.827 329.613 184.827C347.029 184.827 360.205 198.572 360.205 215.997Z" fill="black"/> <path d="M267.88 255.241H278.533V192.465C278.527 188.128 276.801 183.97 273.736 180.904C270.672 177.837 266.517 176.112 262.182 176.106C259.079 176.114 256.043 177.002 253.424 178.666C250.805 180.33 248.712 182.702 247.385 185.508L222.098 239.357C221.634 240.335 220.905 241.162 219.992 241.742C219.079 242.322 218.021 242.631 216.94 242.634C216.191 242.634 215.45 242.487 214.758 242.201C214.067 241.914 213.439 241.494 212.91 240.965C212.381 240.435 211.961 239.807 211.675 239.116C211.389 238.424 211.242 237.683 211.242 236.933V197.771C211.236 192.027 208.952 186.52 204.892 182.458C200.833 178.396 195.328 176.112 189.587 176.106C183.847 176.114 178.344 178.399 174.286 182.461C170.228 186.522 167.945 192.028 167.939 197.771V255.233H178.592V197.771C178.596 194.854 179.755 192.058 181.816 189.994C183.877 187.931 186.671 186.769 189.587 186.764C192.503 186.767 195.3 187.928 197.362 189.992C199.425 192.055 200.585 194.853 200.589 197.771V236.933C200.593 241.271 202.317 245.43 205.382 248.497C208.448 251.563 212.604 253.288 216.94 253.292C220.042 253.285 223.079 252.398 225.697 250.734C228.316 249.069 230.41 246.696 231.736 243.89L257.024 190.041C257.487 189.064 258.218 188.238 259.13 187.658C260.043 187.078 261.101 186.768 262.182 186.764C263.692 186.765 265.141 187.367 266.209 188.435C267.277 189.504 267.878 190.953 267.88 192.465V255.241Z" fill="black"/> <path d="M143.277 176.142H153.601V255.248H143.277V176.142Z" fill="black"/> <path fill-rule="evenodd" clip-rule="evenodd" d="M132.219 215.691C132.219 193.07 114.402 176.142 90.1277 176.142H67L67 255.179H77.7683L90.1277 255.248C114.402 255.248 132.219 238.313 132.219 215.691ZM77.7683 185.836L90.1277 185.836C109.17 185.836 121.749 198.537 121.749 215.691C121.749 232.845 109.17 245.554 90.1277 245.554H77.7683V185.836Z" fill="black"/> </g> </g> <defs> <clipPath id="clip0_136_6"> <rect width="304" height="82" fill="white" transform="translate(67 175)"/> </clipPath> </defs> </svg>'));
        _descriptionToken = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
        _descriptionContract = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
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