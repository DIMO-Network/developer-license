// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.0;

import {Base64} from "./Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract Metadata {

    string public _image;
    string public _description;

    constructor() {
        _image = Base64.encode(bytes('<?xml version="1.0" encoding="UTF-8"?><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><path d="M0 2000 l0 -2000 2000 0 2000 0 0 2000 0 2000 -2000 0 -2000 0 0 -2000z m3353 428 c217 -104 307 -355 204 -571 -77 -163 -242 -258 -421 -244 -137 11 -249 75 -323 186 -59 86 -76 152 -71 265 5 113 42 200 115 274 97 97 194 134 335 128 75 -3 98 -9 161 -38z m-2595 17 c86 -20 156 -58 212 -114 162 -162 158 -430 -8 -582 -106 -97 -181 -119 -404 -119 l-158 0 0 415 0 415 148 0 c94 0 169 -6 210 -15z m572 -400 l0 -415 -55 0 -55 0 0 415 0 415 55 0 55 0 0 -415z m467 386 c46 -23 89 -70 110 -118 10 -24 13 -94 13 -273 0 -227 1 -241 20 -260 23 -23 49 -26 74 -7 9 7 80 145 156 307 86 183 150 307 169 327 62 64 169 67 235 5 55 -52 56 -61 56 -437 l0 -345 -55 0 -55 0 0 335 0 336 -25 25 c-24 24 -54 26 -77 5 -5 -4 -73 -144 -152 -311 -119 -252 -150 -310 -180 -334 -79 -64 -205 -37 -253 54 -22 41 -23 52 -23 279 0 167 -4 243 -13 260 -20 40 -64 66 -109 65 -35 -1 -48 -8 -75 -38 l-33 -36 0 -320 0 -320 -61 0 -60 0 3 328 3 327 28 51 c63 113 192 153 304 95z"/><path d="M3103 2360 c-94 -20 -180 -87 -224 -176 -20 -41 -24 -64 -24 -144 0 -89 2 -99 34 -158 59 -109 155 -165 281 -165 92 0 149 22 219 88 68 64 95 128 96 230 0 56 -6 95 -19 130 -25 64 -104 147 -164 173 -57 24 -142 34 -199 22z"/><path d="M520 2047 l0 -317 89 0 c121 0 203 26 269 85 147 132 129 381 -36 486 -62 39 -98 48 -219 56 l-103 6 0 -316z"/></svg>'));
        _description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
            
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
                            '"description":', _description, ','
                            '"image": "',
                            "data:image/svg+xml;base64,",
                            _image,
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
                            _description,
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            _image,
                            '"}'
                        )
                    )
                )
            )
        );
    }

}