// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console2} from "forge-std/Test.sol";

import {BaseSetUp} from "./helper/BaseSetUp.t.sol";

//forge test --match-path ./test/Integration.t.sol -vv
contract IntegrationTest is BaseSetUp {

    uint256 tokenId;

    function setUp() public {
        _setUp();

        (tokenId,) = license.issueInDimo();
        assertEq(tokenId, 1);
        assertEq(license.ownerOf(tokenId), address(this));
    }

    function test_integration00() public {   
        ///@notice oauth client created for you on the backend

        ///@dev add redirect url
        string memory uri = "https://www.test.com/";
        license.enableRedirectUri(tokenId, uri);

        ///@notice check that the backend has that

        ///@dev add a signer, with a known pk

        ///@dev use that signer to sign a challenge message for that license

        ///@notice check that you can log in as the license address

    }

}
