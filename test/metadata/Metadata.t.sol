// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {console2} from "forge-std/Test.sol";

import {BaseSetUp} from "../helper/BaseSetUp.t.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {IDimoDeveloperLicenseAccount} from "../../src/interface/IDimoDeveloperLicenseAccount.sol";

//forge test --match-path ./test/Metadata.t.sol -vv
contract MetadataTest is BaseSetUp {
    function setUp() public {
        _setUp();
    }

    function test_tokenURI() public {
        (uint256 tokenId,) = license.issueInDimo(LICENSE_ALIAS);

        string memory data00 = license.tokenURI(tokenId);

        string memory data01 = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            string(abi.encodePacked("DIMO Developer License #", Strings.toString(tokenId))),
                            '", "description":"',
                            license.tokenDescription(),
                            '", "image": "',
                            "data:image/svg+xml;base64,",
                            license.tokenImage(),
                            '"}'
                        )
                    )
                )
            )
        );
        assertEq(data00, data01);
    }

    function test_adminResetDescriptionImage() public {
        bytes32 LICENSE_ADMIN_ROLE = keccak256("LICENSE_ADMIN_ROLE");
        //console2.logBytes32(LICENSE_ADMIN_ROLE);

        license.grantRole(LICENSE_ADMIN_ROLE, _admin);

        vm.startPrank(_admin);
        license.setContractImage("image");
        license.setContractDescription("description");
        vm.stopPrank();

        string memory data00 = license.contractURI();

        string memory data01 = string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"DIMO Developer License",' '"description":',
                            "description",
                            "," '"image": "',
                            "data:image/svg+xml;base64,",
                            Base64.encode("image"),
                            '",' '"external_link": "https://dimo.zone/",'
                            '"collaborators": ["0x0000000000000000000000000000000000000000"]}'
                        )
                    )
                )
            )
        );
        assertEq(data00, data01);
    }
}
