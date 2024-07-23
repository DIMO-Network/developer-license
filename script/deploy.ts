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

function getContractFactory(signer: HardhatEthersSigner, contractName: string) {
    const contractJson = JSON.parse(fs.readFileSync(`./out/${contractName}.sol/${contractName}.json`, 'utf8'))
    return new ethers.ContractFactory(contractJson.abi, contractJson.bytecode.object, signer)
}

function getContractInstance(signer: HardhatEthersSigner, contractName: string, contractAddress: string) {
    const contractJson = JSON.parse(fs.readFileSync(`./out/${contractName}.sol/${contractName}.json`, 'utf8'))
    return new ethers.Contract(contractAddress, contractJson.abi, signer)
}

async function deployProvider(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();
    let instances = getAddresses();

    console.log('\n----- Deploying Oracle Source contract -----\n');

    const nameOracle = name === 'amoy' ? 'MockOracleSource' : 'TwapV3'
    const setOracle = getContractFactory(signer, nameOracle)
    const oracle = await setOracle.deploy({ gasPrice: gasPrice })
    await oracle.waitForDeployment()
    const addressOracle = await oracle.getAddress()
    console.log(`${nameOracle} contract deployed to ${addressOracle}`);

    instances[name][nameOracle] = addressOracle;
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressOracle, nameOracle)
    }

    console.log('\n----- Deploying NormalizedPriceProvider contract -----\n');

    gasPrice = await getGasPrice(20n)

    const nameNpp = 'NormalizedPriceProvider'
    const setNpp = getContractFactory(signer, nameNpp)
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

    console.log('\n----- Adding Oracle Source to NormalizedPriceProvider as oracle source -----\n');

    const contractNpp = getContractInstance(signer, nameNpp, addressNpp)
    const txn0x = await contractNpp.grantRole(C.PROVIDER_ADMIN_ROLE, signer.address)
    await txn0x.wait()
    await contractNpp.addOracleSource(addressOracle)

    console.log('----- Oracle Source added -----');
}

async function deployDimoCredit(signer: HardhatEthersSigner, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n)
    const { name } = await ethers.provider.getNetwork();

    const instances = getAddresses();

    const addressDimoToken = instances[name].DimoToken;
    const addressReceiver = instances[name].Receiver;
    const addressNpp = instances[name].NormalizedPriceProvider;

    console.log('\n----- Deploying DimoCredit contract -----\n');

    const nameDc = 'DimoCredit';
    const factoryDc = getContractFactory(signer, nameDc)
    const factoryProxy = getContractFactory(signer, 'ERC1967Proxy')

    const impl = await factoryDc.deploy({ gasPrice: gasPrice });
    await impl.waitForDeployment();
    const addressImplDc = await impl.getAddress();

    const proxy = await factoryProxy.deploy(addressImplDc, "0x", { gasPrice: gasPrice });
    await proxy.waitForDeployment();

    const dimoCredit: any = impl.attach(await proxy.getAddress());
    await dimoCredit.initialize(
        C.DIMO_CREDIT_NAME,
        C.DIMO_CREDIT_SYMBOL,
        addressDimoToken,
        addressReceiver,
        addressNpp,
        C.DIMO_CREDIT_PERIOD_VALIDITY,
        C.DIMO_CREDIT_RATE_IN_WEI
    )

    const addressDc = await proxy.getAddress();
    console.log(`DimoCredit contract deployed to ${addressDc}`);

    instances[name].DimoCredit.proxy = addressDc;
    instances[name].DimoCredit.implementation = await impl.getAddress();
    writeAddresses(instances, name)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDc, nameDc)
    }
}

async function deployLicenseAccountFactory(signer: HardhatEthersSigner, verifyContract: boolean = false) {
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

async function deployDevLicense(signer: HardhatEthersSigner, verifyContract: boolean = false) {
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
        getDevLicenseMetaImage(), // Set to empty if it reverts due to too much data
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

async function grantAdminRoles(signer: HardhatEthersSigner, admin: string) {
    const instances = getAddresses();
    const { name } = await ethers.provider.getNetwork();
    const oracleSourceName = name === 'amoy' ? 'MockOracleSource' : 'TwapV3';

    const oracleSourceInstance = getContractInstance(signer, oracleSourceName, instances[name][oracleSourceName])
    const devLicenseDimoInstance = getContractInstance(signer, 'DevLicenseDimo', instances[name].DevLicenseDimo.proxy)
    const dimoCreditInstance = getContractInstance(signer, 'DimoCredit', instances[name].DimoCredit.proxy)
    const providerInstance = getContractInstance(signer, 'NormalizedPriceProvider', instances[name].NormalizedPriceProvider)
    const factoryInstance = getContractInstance(signer, 'LicenseAccountFactory', instances[name].LicenseAccountFactory.proxy)

    console.log(`\n----- Granting roles to ${admin} -----\n`)

    await devLicenseDimoInstance.grantRole(C.LICENSE_ADMIN_ROLE, admin)
    console.log(`Dev License DIMO: LICENSE_ADMIN_ROLE (${C.LICENSE_ADMIN_ROLE}) granted`)
    await devLicenseDimoInstance.grantRole(C.REVOKER_ROLE, admin)
    console.log(`Dev License DIMO: REVOKER_ROLE (${C.REVOKER_ROLE}) granted`)
    await devLicenseDimoInstance.grantRole(C.UPGRADER_ROLE, admin)
    console.log(`Dev License DIMO: UPGRADER_ROLE (${C.UPGRADER_ROLE}) granted`)

    await factoryInstance.grantRole(C.ADMIN_ROLE, admin);
    console.log(`License Account Factory: ADMIN_ROLE (${C.ADMIN_ROLE}) granted`)
    await factoryInstance.grantRole(C.UPGRADER_ROLE, admin);
    console.log(`License Account Factory: UPGRADER_ROLE (${C.UPGRADER_ROLE}) granted`)

    await dimoCreditInstance.grantRole(C.DC_ADMIN_ROLE, admin);
    console.log(`DIMO Credit: DC_ADMIN_ROLE (${C.DC_ADMIN_ROLE}) granted`)
    await dimoCreditInstance.grantRole(C.UPGRADER_ROLE, admin);
    console.log(`DIMO Credit: UPGRADER_ROLE (${C.UPGRADER_ROLE}) granted`)
    await dimoCreditInstance.grantRole(C.BURNER_ROLE, admin);
    console.log(`DIMO Credit: BURNER_ROLE (${C.BURNER_ROLE}) granted`)

    await oracleSourceInstance.grantRole(C.ORACLE_ADMIN_ROLE, admin);
    console.log(`Oracle Source: ORACLE_ADMIN_ROLE (${C.ORACLE_ADMIN_ROLE}) granted`);

    await providerInstance.grantRole(C.PROVIDER_ADMIN_ROLE, admin);
    console.log(`Normalized Price Provider: PROVIDER_ADMIN_ROLE (${C.PROVIDER_ADMIN_ROLE}) granted`)
    await providerInstance.grantRole(C.UPDATER_ROLE, admin);
    console.log(`Normalized Price Provider: UPDATER_ROLE (${C.UPDATER_ROLE}) granted`)

    console.log(`\n----- Roles granted -----`)
}

async function setup(signer: HardhatEthersSigner) {
    const instances = getAddresses();

    const { name } = await ethers.provider.getNetwork();

    const addressDl = instances[name].DevLicenseDimo.proxy;

    console.log('\n----- Starting setup -----\n');

    const factoryInstance = getContractInstance(signer, 'LicenseAccountFactory', instances[name].LicenseAccountFactory.proxy)
    const dimoCreditInstance = getContractInstance(signer, 'DimoCredit', instances[name].DimoCredit.proxy)

    if (!(await factoryInstance.hasRole(C.ADMIN_ROLE, signer.address))) {
        console.log(`Granting ADMIN_ROLE (${C.ADMIN_ROLE}) to ${signer.address}`)
        await (await factoryInstance.grantRole(C.ADMIN_ROLE, signer.address)).wait();
        console.log(`License Account Factory: ADMIN_ROLE (${C.ADMIN_ROLE}) granted`);
    }

    console.log('Setting LicenseAccountFactory to DevLicenseDimo');
    await factoryInstance.setDevLicenseDimo(addressDl)
    console.log('LicenseAccountFactory set');

    console.log(`Granting BURNER_ROLE (${C.BURNER_ROLE}) to ${addressDl}`)
    await dimoCreditInstance.grantRole(C.BURNER_ROLE, addressDl);
    console.log(`DIMO Credit: BURNER_ROLE (${C.BURNER_ROLE}) granted`)

    console.log('\n----- Setup done -----');
}

async function verifyContractUntilSuccess(address: any, contractName: string, arg?: any[]) {
    const { chainId } = await ethers.provider.getNetwork();
    const apiKey = process.env.POLYGONSCAN_API_KEY as string;
    let verifier = ''

    if (chainId.toString() === '80002') {//amoy
        verifier = '--verifier-url https://api-amoy.polygonscan.com/api'
    }

    return new Promise((resolve, _) => {

        console.log(`\n----- Verifying ${contractName} contract at ${address} -----\n`);

        let command: string;
        if (!arg) {
            command = `forge verify-contract ${verifier} ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey}`;
        } else {
            command = `forge verify-contract ${verifier} ${address} ${contractName} --chain-id ${chainId} --etherscan-api-key ${apiKey} --constructor-args ${arg.toString()}`;
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
    const instances = getAddresses();
    const { name } = await ethers.provider.getNetwork();

    await deployProvider(signer);
    await deployDimoCredit(signer);
    await deployLicenseAccountFactory(signer);
    await deployDevLicense(signer);

    await grantAdminRoles(signer, instances[name].Admin);

    await setup(signer);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
