import * as fs from 'fs'
import path from 'path'
import { BaseContract } from 'ethers'
import { ethers } from 'hardhat';
import { HardhatEthersSigner } from "@nomicfoundation/hardhat-ethers/signers";
import { exec } from 'child_process'

import * as C from './data/deployArgs';

type AddressesByNetwork = {
    [index: string]: string
};

function getAddresses() {
    return JSON.parse(
        fs.readFileSync(path.resolve(__dirname, 'data', 'addresses.json'), 'utf8'),
    );
}

function writeAddresses(addresses: AddressesByNetwork, networkName: string) {
    console.log('\n----- Writing addresses to file -----');

    const currentAddresses: AddressesByNetwork = addresses;
    currentAddresses[networkName] = addresses[networkName];

    fs.writeFileSync(
        path.resolve(__dirname, 'data', 'addresses.json'),
        JSON.stringify(currentAddresses, null, 4),
    );

    console.log('----- Addresses written to file -----\n');
}

async function getGasPrice(bump: bigint = 20n): Promise<bigint> {
    if (bump < 1n) {
        throw new Error('gas price bump must be >= 1');
    }

    const price = (await ethers.provider.getFeeData()).gasPrice as bigint;
    return (price * bump / 100n + price);
}

function getContractFactory(signer: HardhatEthersSigner, contractName: string) {
    const contractJson = JSON.parse(fs.readFileSync(`./out/${contractName}.sol/${contractName}.json`, 'utf8'))
    return new ethers.ContractFactory(contractJson.abi, contractJson.bytecode.object, signer)
}

function getContractInstance(signer: HardhatEthersSigner, contractName: string, contractAddress: string) {
    const contractJson = JSON.parse(fs.readFileSync(`./out/${contractName}.sol/${contractName}.json`, 'utf8'))
    return new ethers.Contract(contractAddress, contractJson.abi, signer)
}

async function upgradeDimoCredit(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n)

    const instances = getAddresses();

    const addressProxy = instances[networkName].DimoCredit.proxy;

    console.log('\n----- Upgrading DimoCredit contract -----\n');

    const nameDc = 'DimoCredit';
    const factoryDc = getContractFactory(signer, nameDc)

    const impl = await factoryDc.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImplDc = await impl.getAddress();

    console.log(`${nameDc} contract implementation deployed to ${addressImplDc}`);

    const proxy = getContractInstance(signer, nameDc, addressProxy)
    await proxy.upgradeToAndCall(addressImplDc, '0x');

    console.log(`${nameDc} contract was upgraded to ${addressImplDc}`);

    instances[networkName].DimoCredit.implementation = addressImplDc;
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressImplDc, nameDc)
    }
}

async function upgradeLicenseAccountFactory(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();
    const instances = getAddresses();

    const admin = instances[name].Admin;

    console.log('\n----- Deploying DimoDeveloperLicenseAccount template contract -----\n');

    const nameDdla = 'DimoDeveloperLicenseAccount';
    const factoryDdla = getContractFactory(signer, nameDdla)
    const devLicenseAccount: BaseContract = await factoryDdla.deploy({ gasPrice: gasPrice })
    await devLicenseAccount.waitForDeployment();
    const addressDdla = await devLicenseAccount.getAddress();
    console.log(`DimoDeveloperLicenseAccount contract deployed to ${addressDdla}`);

    instances[name].DimoDeveloperLicenseAccount = addressDdla;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDdla, nameDdla)
    }

    console.log('\n----- Deploying UpgradeableBeacon contract -----\n');

    gasPrice = await getGasPrice(20n)

    const beaconFactory = getContractFactory(signer, 'UpgradeableBeacon')
    const beacon = await beaconFactory.deploy(addressDdla, admin, { gasPrice: gasPrice });
    await beacon.waitForDeployment();
    const addressBeacon = await beacon.getAddress();
    console.log(`UpgradeableBeacon contract deployed to ${addressDdla}`);

    instances[name].UpgradeableBeacon = addressBeacon;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressBeacon, 'UpgradeableBeacon', [addressDdla, admin])
    }

    console.log('\n----- Deploying LicenseAccountFactory contract -----\n');

    gasPrice = await getGasPrice(20n)

    const nameLaf = 'LicenseAccountFactory';
    const factoryLaf = getContractFactory(signer, nameLaf)
    const factoryProxy = getContractFactory(signer, 'ERC1967Proxy')

    const impl = await factoryLaf.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImplLaf = await impl.getAddress();

    console.log(`${nameLaf} contract implementation deployed to ${addressImplLaf}`);

    const proxy = await factoryProxy.deploy(addressImplLaf, "0x", { gasPrice: gasPrice });
    await proxy.waitForDeployment();

    const licenseAccountFactory: any = impl.attach(await proxy.getAddress());
    await licenseAccountFactory.initialize(addressBeacon)

    const addressLaf = await proxy.getAddress();
    console.log(`LicenseAccountFactory contract deployed to ${addressLaf}`);

    instances[name].LicenseAccountFactory.proxy = addressLaf;
    instances[name].LicenseAccountFactory.implementation = await impl.getAddress();
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressLaf, nameLaf)
    }
}

async function upgradeDevLicense(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    const instances = getAddresses();

    let gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();

    const addressReceiver = instances[name].Receiver;
    const addressLaf = instances[name].LicenseAccountFactory.proxy;
    const addressNpp = instances[name].NormalizedPriceProvider;
    const addressDimoToken = instances[name].DimoToken;
    const addressDc = instances[name].DimoCredit.proxy;
    const licenseCostInUsd = C.licenseCostInUsd;

    console.log('\n----- Deploying DevLicenseDimo contract -----\n');

    const nameDl = 'DevLicenseDimo';
    const factoryDl = getContractFactory(signer, nameDl)
    const factoryProxy = getContractFactory(signer, 'ERC1967Proxy')

    const impl = await factoryDl.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImplDl = await impl.getAddress();

    console.log(`${nameDl} contract implementation deployed to ${addressImplDl}`);

    const proxy = await factoryProxy.deploy(addressImplDl, '0x', { gasPrice: gasPrice });
    await proxy.waitForDeployment();

    const devLicenseDimo: any = impl.attach(await proxy.getAddress());
    await devLicenseDimo.initialize(
        addressReceiver,
        addressLaf,
        addressNpp,
        addressDimoToken,
        addressDc,
        licenseCostInUsd,
        "",
        C.METADATA_DESCRIPTION
    )

    const addressDl = await proxy.getAddress();
    console.log(`DevLicenseDimo contract deployed to ${addressDl}`);

    instances[name].DevLicenseDimo.proxy = addressDl;
    instances[name].DevLicenseDimo.implementation = await impl.getAddress();
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDl, nameDl)
    }
}

async function verifyContractUntilSuccess(address: any, contractName: string, arg?: any[]) {
    const { chainId } = await ethers.provider.getNetwork();
    const apiKey = process.env.POLYGONSCAN_API_KEY as string;

    return new Promise((resolve, _) => {

        console.log(`\n----- Verifying ${contractName} contract at ${address} -----\n`);

        let command: string;
        if (!arg) {
            command = `forge verify-contract ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey}`;
        } else {
            command = `forge verify-contract ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey} --constructor-args ${arg.toString()}`;
        }

        const attemptVerification = () => {
            exec(command, (error, stdout, stderr) => {
                if (error) {
                    console.error(`exec error: ${error}`);
                    setTimeout(attemptVerification, 1000); // Try again after 1 second
                    return;
                }
                // stdout contains the output of the command
                let output = stdout;
                console.log(`Output: ${output}`);
                if (stderr) {
                    console.error(`stderr: ${stderr}`);
                }
                // Check if the output indicates success
                if (output.includes("OK")) {
                    resolve(output);
                    return;
                } else {
                    setTimeout(attemptVerification, 1000); // Try again after 1 second
                }
            });
        };
        attemptVerification();
    });
}

async function main() {
    let [deployer, user1] = await ethers.getSigners();
    let { name } = await ethers.provider.getNetwork();

    if (name === 'localhost') {
        name = 'amoy'
        // 0x62b98e019e0d3e4A1Ad8C786202e09017Bd995e1 Prod account
        // 0x07B584f6a7125491C991ca2a45ab9e641B1CeE1b Shared dev account
        deployer = await ethers.getImpersonatedSigner(
            '0x07B584f6a7125491C991ca2a45ab9e641B1CeE1b'
        );

        await user1.sendTransaction({
            to: deployer.address,
            value: ethers.parseEther('10')
        });
    }

    await upgradeDimoCredit(deployer, name, false);
    await upgradeLicenseAccountFactory(deployer, false);
    await upgradeDevLicense(deployer, false);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
