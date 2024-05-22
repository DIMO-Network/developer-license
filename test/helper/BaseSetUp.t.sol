// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";

import {Upgrades, Options} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {IERC1271} from "openzeppelin-contracts/contracts/interfaces/IERC1271.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {TwapV3} from "../../src/provider/TwapV3.sol";
import {NormalizedPriceProvider} from "../../src/provider/NormalizedPriceProvider.sol";
import {DimoCredit} from "../../src/DimoCredit.sol";
import {DevLicenseDimo} from "../../src/DevLicenseDimo.sol";
import {DimoDeveloperLicenseAccount} from "../../src/DimoDeveloperLicenseAccount.sol";
import {LicenseAccountFactory} from "../../src/LicenseAccountFactory.sol";

contract BaseSetUp is Test {
    bytes32 constant LICENSE_ALIAS = "licenseAlias";
    string constant IMAGE_SVG =
        '<svg width="1872" height="1872" viewBox="0 0 1872 1872" fill="none" xmlns="http://www.w3.org/2000/svg"> <rect width="1872" height="1872" fill="#191919"/></svg>';
    string constant METADATA_DESCRIPTION =
        "This is an NFT collection minted for developers building on the DIMO Network";

    ERC20 public dimoToken;
    DevLicenseDimo public license;

    DimoCredit public dimoCredit;
    NormalizedPriceProvider public provider;

    address _receiver;
    address _admin;
    address _licenseHolder;

    function _setUp() public {
        _receiver = address(0x123);
        _admin = address(0x1);
        _licenseHolder = address(0x999);

        //vm.createSelectFork('https://polygon-mainnet.g.alchemy.com/v2/NlPy1jSLyP-tUCHAuilxrsfaLcFaxSTm', 50573735);
        vm.createSelectFork("https://polygon-mainnet.infura.io/v3/89d890fd291a4096a41aea9b3122eb28", 50573735);
        dimoToken = ERC20(0xE261D618a959aFfFd53168Cd07D12E37B26761db);

        LicenseAccountFactory laf = new LicenseAccountFactory();

        provider = new NormalizedPriceProvider();
        provider.grantRole(keccak256("PROVIDER_ADMIN_ROLE"), address(this));

        TwapV3 twap = new TwapV3();
        twap.grantRole(keccak256("ORACLE_ADMIN_ROLE"), address(this));

        uint32 intervalUsdc = 30 minutes;
        //console2.log("intervalUsdc: %s", intervalUsdc);
        uint32 intervalDimo = 4 minutes;
        //console2.log("intervalDimo: %s", intervalDimo);
        twap.initialize(intervalUsdc, intervalDimo);
        provider.addOracleSource(address(twap));

        //(uint256 amountUsdPerToken, uint256 updateTimestamp) = provider.getAmountUsdPerToken();
        //console2.log("amountUsdPerToken: %s", amountUsdPerToken);
        //console2.log("  updateTimestamp: %s", updateTimestamp);

        dimoCredit = new DimoCredit(address(0x123), address(provider));

        uint256 licenseCostInUsd1e18 = 100 ether;

        Options memory opts;
        opts.unsafeSkipAllChecks = true;

        address proxy = Upgrades.deployUUPSProxy(
            "DevLicenseDimo.sol",
            abi.encodeCall(
                DevLicenseDimo.initialize,
                (
                    address(0x888),
                    address(laf),
                    address(provider),
                    address(dimoToken),
                    address(dimoCredit),
                    licenseCostInUsd1e18,
                    IMAGE_SVG,
                    METADATA_DESCRIPTION
                )
            ),
            opts
        );

        license = DevLicenseDimo(proxy);

        laf.setLicense(address(license));
        deal(address(dimoToken), address(this), 1_000_000 ether);
        dimoToken.approve(address(license), 1_000_000 ether);
    }
}
