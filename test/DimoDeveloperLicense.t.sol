// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";


contract MockDimoToken is ERC20, Test {
    constructor() ERC20("DIMO Token", "DIMO") {
        _mint(msg.sender, 1_000_000 ether);
    }

    function mint(address user, uint256 amount) public {
        _mint(user, amount);
    }
}

//forge test --match-path ./test/DimoDeveloperLicense.t.sol -vv
contract DimoDeveloperLicenseTest is Test {

    MockDimoToken dimoToken;
    DimoDeveloperLicense license;

    function setUp() public {

        LicenseAccountFactory laf = new LicenseAccountFactory();
        
        dimoToken = new MockDimoToken();
        license = new DimoDeveloperLicense(address(laf), address(dimoToken), 10_000 ether);
        dimoToken.approve(address(license), 10_000 ether);
    }

    function test_MintLicenseSuccess() public {
        
        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.LicenseMinted(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.mint("vehicle_genius");
        assertEq(tokenId, 1);

        assertEq(license.ownerOf(tokenId), address(this));
        assertEq(dimoToken.balanceOf(address(license)), 10_000 ether);
    }

    function test_DeveloperLicenseAccount() public {

        uint256 privateKey = 0x1337;
        address user = vm.addr(privateKey);

        dimoToken.mint(user, 10_000 ether);

        vm.startPrank(user);
        dimoToken.approve(address(license), 10_000 ether);
        (uint256 tokenId, address accountAddress) = license.mint("solala");
        license.enableSigner(tokenId, user);
        vm.stopPrank();

        bool signer = license.isSigner(tokenId, user);
        console2.log("signer: %s", signer);

        bytes32 hashValue = keccak256(
            abi.encodePacked(
                keccak256(
                    "\x19Ethereum Signed Message:\n32"
                ),
                keccak256("Hello World")
            )   
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hashValue);
        bytes memory signature = abi.encodePacked(r, s, v); 
        bytes4 output = DimoDeveloperLicenseAccount(accountAddress).isValidSignature(hashValue, signature);
        //0x1626ba7e
        console2.logBytes4(output);
    }

    
}
