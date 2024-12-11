// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Vm} from "forge-std/Vm.sol";

library EventUtils {
    function captureEventTopics(Vm.Log[] memory entries, string memory signature, address emitter)
        internal
        pure
        returns (bytes32[] memory args)
    {
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == keccak256(bytes(signature)) && entries[i].emitter == emitter) {
                return entries[i].topics;
            }
        }
    }

    function captureEventData(Vm.Log[] memory entries, string memory signature, address emitter)
        internal
        pure
        returns (bytes memory args)
    {
        for (uint256 i = 0; i < entries.length; i++) {
            if (entries[i].topics[0] == keccak256(bytes(signature)) && entries[i].emitter == emitter) {
                return entries[i].data;
            }
        }
    }
}
