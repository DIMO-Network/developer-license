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

async function upgradeLicenseAccount(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    const instances = getAddresses();
    const nameDdla = 'DimoDeveloperLicenseAccount';

    console.log(`\n----- Upgrading ${nameDdla} template contract -----\n`);

    const factoryDdla = getContractFactory(signer, nameDdla)
    const devLicenseAccount: BaseContract = await factoryDdla.deploy({ gasPrice: gasPrice })
    await devLicenseAccount.waitForDeployment();
    const addressDdla = await devLicenseAccount.getAddress();

    console.log(`${nameDdla} contract implementation deployed to ${addressDdla}`);

    const addressProxy = instances[networkName].UpgradeableBeacon;
    const proxy = getContractInstance(signer, 'UpgradeableBeacon', addressProxy)
    await (await proxy.upgradeTo(addressDdla)).wait()

    console.log(`${nameDdla} template contract was upgraded to ${addressDdla}`);

    instances[networkName].DimoDeveloperLicenseAccount = addressDdla;
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDdla, nameDdla)
    }
}

async function upgradeContract(
    contractName: "DevLicenseDimo" | "DimoCredit" | "LicenseAccountFactory",
    signer: HardhatEthersSigner,
    networkName: string,
    verifyContract: boolean = false
) {
    const gasPrice = await getGasPrice(20n)

    const instances = getAddresses();

    const addressProxy = instances[networkName][contractName].proxy;

    console.log(`\n----- Upgrading ${contractName} contract -----\n`);

    const factory = getContractFactory(signer, contractName)

    const impl = await factory.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImpl = await impl.getAddress();

    console.log(`${contractName} contract implementation deployed to ${addressImpl}`);

    const proxy = getContractInstance(signer, contractName, addressProxy)
    await proxy.upgradeToAndCall(addressImpl, '0x');

    console.log(`${contractName} contract was upgraded to ${addressImpl}`);

    instances[networkName][contractName].implementation = addressImpl;
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressImpl, contractName)
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
        // 0xC008EF40B0b42AAD7e34879EB024385024f753ea Shared dev account
        deployer = await ethers.getImpersonatedSigner(
            '0xC008EF40B0b42AAD7e34879EB024385024f753ea'
        );

        await user1.sendTransaction({
            to: deployer.address,
            value: ethers.parseEther('10')
        });
    }

    await upgradeContract("DimoCredit", deployer, name, false);
    await upgradeContract("DevLicenseDimo", deployer, name, false);
    await upgradeContract("LicenseAccountFactory", deployer, name, false);
    await upgradeLicenseAccount(deployer, name, false);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
