// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";

/**
 */
contract ForkProvider is Test {
    string public _url;

    constructor() {
        _url = vm.envString("POLYGON_URL");
    }
}
