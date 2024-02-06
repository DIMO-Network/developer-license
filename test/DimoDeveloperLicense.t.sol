// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {DimoDeveloperLicense} from "../src/DimoDeveloperLicense.sol";
import {DimoDeveloperLicenseAccount} from "../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../src/LicenseAccountFactory.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {ERC20} from "solmate/src/tokens/ERC20.sol";

import {TwapV3} from "../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../src/provider/NormalizedPriceProvider.sol";

//forge test --match-path ./test/DimoDeveloperLicense.t.sol -vv
contract DimoDeveloperLicenseTest is Test {

    address dimoToken;
    DimoDeveloperLicense license;

    function setUp() public {
        vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);

        LicenseAccountFactory laf = new LicenseAccountFactory();

        NormalizedPriceProvider npp = new NormalizedPriceProvider();

        TwapV3 twap = new TwapV3();
        uint32 twapIntervalUsdc = 30 minutes;
        uint32 twapIntervalDimo = 4 minutes; 
        twap.initialize(twapIntervalUsdc, twapIntervalDimo);
        npp.addOracleSource(address(twap));

        license = new DimoDeveloperLicense(
            address(laf), 
            address(npp), 
            0xE261D618a959aFfFd53168Cd07D12E37B26761db, 
            address(0),
            100
        );

        laf.setLicense(address(license));
        deal(0xE261D618a959aFfFd53168Cd07D12E37B26761db, address(this), 1_000_000 ether);
        ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db).approve(address(license), 1_000_000 ether);
    }

    function test_mintLicenseSuccess() public {
        
        vm.expectEmit(true, true, false, true);
        emit DimoDeveloperLicense.Issued(1, address(this), address(0), "vehicle_genius");

        (uint256 tokenId,) = license.issueInDimo("vehicle_genius");
        assertEq(tokenId, 1);

        assertEq(license.ownerOf(tokenId), address(this));
        assertEq(ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db).balanceOf(address(license)), 10_000 ether);
    }

    // function test_developerLicenseAccount() public {

    //     uint256 privateKey = 0x1337;
    //     address user = vm.addr(privateKey);

    //     dimoToken.mint(user, 10_000 ether);

    //     vm.startPrank(user);
    //     dimoToken.approve(address(license), 10_000 ether);
    //     (uint256 tokenId, address accountAddress) = license.issueInDimo("solala");
    //     license.enableSigner(tokenId, user);
    //     vm.stopPrank();

    //     bool signer = license.isSigner(tokenId, user);
    //     console2.log("signer: %s", signer);

    //     bytes32 hashValue = keccak256(
    //         abi.encodePacked(
    //             keccak256(
    //                 "\x19Ethereum Signed Message:\n32"
    //             ),
    //             keccak256("Hello World")
    //         )   
    //     );
    //     (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, hashValue);
    //     bytes memory signature = abi.encodePacked(r, s, v); 
    //     bytes4 output = DimoDeveloperLicenseAccount(accountAddress).isValidSignature(hashValue, signature);
    //     //0x1626ba7e
    //     console2.logBytes4(output);
    //     assertEq(IERC1271.isValidSignature.selector, output);
    // }

    // function test_existsLocked() public {
    //     (uint256 tokenId,) = license.issueInDimo("test");

    //     bool locked = license.locked(tokenId);
    //     assertEq(locked, true);

    //     vm.expectRevert("DimoDeveloperLicense: invalid tokenId");
    //     license.locked(300);
    // }

    
}
