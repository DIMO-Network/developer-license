// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol"; 
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

//forge test --match-path ./test/LicenseAccountFactory.t.sol -vv
contract LicenseAccountFactoryTest is Test {

    DimoDeveloperLicense license;
    MockDimoToken dimoToken;

    function setUp() public {

        LicenseAccountFactory laf = new LicenseAccountFactory();
        
        //dimoToken = new MockDimoToken();
        license = new DimoDeveloperLicense(address(laf), address(dimoToken), 10_000 ether);
        dimoToken.approve(address(license), 10_000 ether);
    }

    /**
     * 
     */
    function test_001() public {

        
    
    }

}

contract MockDimoToken is ERC20, Test {
    constructor() ERC20("DIMO Token", "DIMO") {
        _mint(msg.sender, 1_000_000 ether);
    }

    function mint(address user, uint256 amount) public {
        _mint(user, amount);
    }
}