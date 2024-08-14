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

async function deployProvider(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    let instances = getAddresses();

    console.log('\n----- Deploying Oracle Source contract -----\n');

    const nameOracle = networkName === 'amoy' ? 'MockOracleSource' : 'TwapV3'
    const setOracle = getContractFactory(signer, nameOracle)
    const oracle = await setOracle.deploy({ gasPrice: gasPrice })
    await oracle.waitForDeployment()
    const addressOracle = await oracle.getAddress()
    console.log(`${nameOracle} contract deployed to ${addressOracle}`);

    instances[networkName][nameOracle] = addressOracle;
    writeAddresses(instances, networkName)

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
    instances[networkName].NormalizedPriceProvider = addressNpp;
    writeAddresses(instances, networkName)

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

async function deployDimoCredit(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n)
    const instances = getAddresses();

    const addressDimoToken = instances[networkName].DimoToken;
    const addressReceiver = instances[networkName].Receiver;
    const addressNpp = instances[networkName].NormalizedPriceProvider;

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

    instances[networkName].DimoCredit.proxy = addressDc;
    instances[networkName].DimoCredit.implementation = await impl.getAddress();
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDc, nameDc)
    }
}

async function deployLicenseAccountFactory(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n)
    const instances = getAddresses();

    const admin = instances[networkName].Admin;

    console.log('\n----- Deploying DimoDeveloperLicenseAccount template contract -----\n');

    const nameDdla = 'DimoDeveloperLicenseAccount';
    const factoryDdla = getContractFactory(signer, nameDdla)
    const devLicenseAccount: BaseContract = await factoryDdla.deploy({ gasPrice: gasPrice })
    await devLicenseAccount.waitForDeployment();
    const addressDdla = await devLicenseAccount.getAddress();
    console.log(`DimoDeveloperLicenseAccount contract deployed to ${addressDdla}`);

    instances[networkName].DimoDeveloperLicenseAccount = addressDdla;
    writeAddresses(instances, networkName)

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

    instances[networkName].UpgradeableBeacon = addressBeacon;
    writeAddresses(instances, networkName)

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

    instances[networkName].LicenseAccountFactory.proxy = addressLaf;
    instances[networkName].LicenseAccountFactory.implementation = await impl.getAddress();
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressLaf, nameLaf)
    }
}

async function deployDevLicense(signer: HardhatEthersSigner, networkName: string, verifyContract: boolean = false) {
    const instances = getAddresses();
    let gasPrice = await getGasPrice(20n)

    const addressReceiver = instances[networkName].Receiver;
    const addressLaf = instances[networkName].LicenseAccountFactory.proxy;
    const addressNpp = instances[networkName].NormalizedPriceProvider;
    const addressDimoToken = instances[networkName].DimoToken;
    const addressDc = instances[networkName].DimoCredit.proxy;
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

    instances[networkName].DevLicenseDimo.proxy = addressDl;
    instances[networkName].DevLicenseDimo.implementation = await impl.getAddress();
    writeAddresses(instances, networkName)

    if (verifyContract) {
        await verifyContractUntilSuccess(addressDl, nameDl)
    }
}

async function grantAdminRoles(signer: HardhatEthersSigner, networkName: string, admin: string) {
    const instances = getAddresses();
    const oracleSourceName = networkName === 'amoy' ? 'MockOracleSource' : 'TwapV3';

    const oracleSourceInstance = getContractInstance(signer, oracleSourceName, instances[networkName][oracleSourceName])
    const devLicenseDimoInstance = getContractInstance(signer, 'DevLicenseDimo', instances[networkName].DevLicenseDimo.proxy)
    const dimoCreditInstance = getContractInstance(signer, 'DimoCredit', instances[networkName].DimoCredit.proxy)
    const providerInstance = getContractInstance(signer, 'NormalizedPriceProvider', instances[networkName].NormalizedPriceProvider)
    const factoryInstance = getContractInstance(signer, 'LicenseAccountFactory', instances[networkName].LicenseAccountFactory.proxy)

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

async function setup(signer: HardhatEthersSigner, networkName: string) {
    const instances = getAddresses();

    const addressDl = instances[networkName].DevLicenseDimo.proxy;

    console.log('\n----- Starting setup -----\n');

    const factoryInstance = getContractInstance(signer, 'LicenseAccountFactory', instances[networkName].LicenseAccountFactory.proxy)
    const dimoCreditInstance = getContractInstance(signer, 'DimoCredit', instances[networkName].DimoCredit.proxy)

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
    let [signer, user1] = await ethers.getSigners();
    const instances = getAddresses();
    let { name } = await ethers.provider.getNetwork();

    if (name === 'localhost') {
        name = 'polygon'
        // 0x62b98e019e0d3e4A1Ad8C786202e09017Bd995e1 Prod account
        // 0x07B584f6a7125491C991ca2a45ab9e641B1CeE1b Shared dev account
        signer = await ethers.getImpersonatedSigner(
            '0x62b98e019e0d3e4A1Ad8C786202e09017Bd995e1'
        );

        await user1.sendTransaction({
            to: signer.address,
            value: ethers.parseEther('10')
        });
    }

    await deployProvider(signer, name);
    await deployDimoCredit(signer, name);
    await deployLicenseAccountFactory(signer, name);
    await deployDevLicense(signer, name);

    await grantAdminRoles(signer, instances[name].Admin, name);

    await setup(signer, name);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
