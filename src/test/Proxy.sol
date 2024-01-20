// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Proxy {
    bytes32 constant IMPLEMENTATION_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    function upgradeTo(address newImpl) external {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            sstore(slot, newImpl)
        }
    }

    function implementation() public view returns(address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }

    fallback() external payable {
        (bool ok, bytes memory returnData) = implementation().delegatecall(msg.data);

        if(!ok)
            revert("Calling logic contract failed");

        // Forward the return value
        assembly {
            let data := add(returnData, 32)
            let size := mload(returnData)
            return(data, size)
        }
    }

    receive() external payable {}
}