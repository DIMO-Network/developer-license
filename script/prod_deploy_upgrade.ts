import dotenv from 'dotenv'
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

function getDevLicenseMetaImage() {
    return fs.readFileSync(path.resolve(__dirname, '..', 'svg', 'devLicenseMetaImage.svg'), 'utf8')
}

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

async function deployProvider(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();
    let instances = getAddresses();

    console.log('\n----- Deploying TwapV3 contract -----\n');

    const nameTwap = 'TwapV3'
    const outTwap = JSON.parse(fs.readFileSync(`./out/${nameTwap}.sol/${nameTwap}.json`, 'utf8'))
    const setTwap = new ethers.ContractFactory(outTwap.abi, outTwap.bytecode.object, signer)
    const twap = await setTwap.deploy({ gasPrice: gasPrice })
    await twap.waitForDeployment()
    const addressTwap = await twap.getAddress()
    console.log(`TwapV3 contract deployed to ${addressTwap}`);

    instances[name].TwapV3 = addressTwap;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressTwap, nameTwap)
    }

    console.log('\n----- Deploying NormalizedPriceProvider contract -----\n');

    gasPrice = await getGasPrice(20n)

    const nameNpp = 'NormalizedPriceProvider'
    const outNpp = JSON.parse(fs.readFileSync(`./out/${nameNpp}.sol/${nameNpp}.json`, 'utf8'))
    const setNpp = new ethers.ContractFactory(outNpp.abi, outNpp.bytecode.object, signer)
    const normalizedPriceProvider = await setNpp.deploy({ gasPrice: gasPrice })
    await normalizedPriceProvider.waitForDeployment()
    const addressNpp = await normalizedPriceProvider.getAddress()
    console.log(`NormalizedPriceProvider contract deployed to ${addressNpp}`);

    instances = getAddresses();
    instances[name].NormalizedPriceProvider = addressNpp;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressNpp, nameNpp)
    }

    console.log('\n----- Adding TwapV3 to NormalizedPriceProvider as oracle source -----\n');

    const contractNpp = new ethers.Contract(addressNpp, outNpp.abi, signer)
    const txn0x = await contractNpp.grantRole(C.PROVIDER_ADMIN_ROLE, signer.address)
    await txn0x.wait()
    await contractNpp.addOracleSource(addressTwap)

    console.log('----- TwapV3 added -----');
}

async function deployDimoCredit(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();

    const instances = getAddresses();

    const addressReceiver = instances[name].Receiver;
    const addressNpp = instances[name].NormalizedPriceProvider;

    console.log('\n----- Deploying DimoCredit contract -----\n');

    const nameDc = 'DimoCredit';
    const outDc = JSON.parse(fs.readFileSync(`./out/${nameDc}.sol/${nameDc}.json`, 'utf8'))
    const factoryDc = new ethers.ContractFactory(outDc.abi, outDc.bytecode.object, signer)
    const dimoCredit: BaseContract = await factoryDc.deploy(addressReceiver, addressNpp, { gasPrice: gasPrice })
    await dimoCredit.waitForDeployment()
    const addressDc = await dimoCredit.getAddress()
    console.log(`DimoCredit contract deployed to ${addressDc}`);

    instances[name].DimoCredit = addressDc;
    writeAddresses(instances, name)

    if (verifyContract) {
        const encodeArgsDc = factoryDc.interface.encodeDeploy([addressReceiver, addressNpp])
        await verifyContractUntilSuccess(addressDc, nameDc, encodeArgsDc)
    }
}

async function deployLicenseAccountFactory(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();
    const instances = getAddresses();

    console.log('\n----- Deploying LicenseAccountFactory contract -----\n');

    const nameLaf = 'LicenseAccountFactory';
    const outLaf = JSON.parse(fs.readFileSync(`./out/${nameLaf}.sol/${nameLaf}.json`, 'utf8'))
    const factoryLaf = new ethers.ContractFactory(outLaf.abi, outLaf.bytecode.object, signer)
    const licenseAccountFactory: BaseContract = await factoryLaf.deploy({ gasPrice: gasPrice })
    await licenseAccountFactory.waitForDeployment();
    const addressLaf = await licenseAccountFactory.getAddress();
    console.log(`LicenseAccountFactory contract deployed to ${addressLaf}`);

    instances[name].LicenseAccountFactory = addressLaf;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressLaf, nameLaf)
    }
}

async function deployDevLicense(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    const instances = getAddresses();

    let gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();

    const addressReceiver = instances[name].Receiver;
    const addressLaf = instances[name].LicenseAccountFactory;
    const addressNpp = instances[name].NormalizedPriceProvider;
    const addressDimoToken = instances[name].DimoToken;
    const addressDc = instances[name].DimoCredit;
    const licenseCostInUsd = C.licenseCostInUsd;

    console.log('\n----- Deploying DevLicenseDimo contract -----\n');

    const nameDl = 'DevLicenseDimo';
    const outDl = JSON.parse(fs.readFileSync(`./out/${nameDl}.sol/${nameDl}.json`, 'utf8'))
    const outERC1967Proxy = JSON.parse(fs.readFileSync(`./out/ERC1967Proxy.sol/ERC1967Proxy.json`, 'utf8'))
    const factoryDl = new ethers.ContractFactory(outDl.abi, outDl.bytecode.object, signer)
    const factoryProxy = new ethers.ContractFactory(outERC1967Proxy.abi, outERC1967Proxy.bytecode.object, signer)

    const impl = await factoryDl.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImplDl = await impl.getAddress();

    const proxy = await factoryProxy.deploy(addressImplDl, "0x", { gasPrice: gasPrice });
    await proxy.waitForDeployment();

    const devLicenseDimo: any = impl.attach(await proxy.getAddress());
    await devLicenseDimo.initialize(
        addressReceiver,
        addressLaf,
        addressNpp,
        addressDimoToken,
        addressDc,
        licenseCostInUsd,
        getDevLicenseMetaImage(),
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

    console.log('\n----- Setting LicenseAccountFactory to DevLicenseDimo -----\n');

    const nameLaf = 'LicenseAccountFactory';
    const outLaf = JSON.parse(fs.readFileSync(`./out/${nameLaf}.sol/${nameLaf}.json`, 'utf8'))
    const contractLaf = new ethers.Contract(addressLaf, outLaf.abi, signer)
    await contractLaf.setLicense(addressDl)

    console.log('----- LicenseAccountFactory set -----');
}

async function verifyContractUntilSuccess(address: any, contractName: string, arg?: any) {
    const { chainId } = await ethers.provider.getNetwork();
    const apiKey = process.env.POLYGONSCAN_API_KEY as string;

    return new Promise((resolve, _) => {

        console.log(`\n----- Verifying ${contractName} contract at ${address} -----\n`);

        let command: string;
        if (!arg) {
            command = `forge verify-contract ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey}`;
        } else {
            command = `forge verify-contract ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey} --constructor-args ${arg}`;
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
    const [signer] = await ethers.getSigners();

    await deployProvider(signer);
    await deployDimoCredit(signer);
    await deployLicenseAccountFactory(signer);
    await deployDevLicense(signer);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
