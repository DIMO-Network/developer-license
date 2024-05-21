import dotenv from 'dotenv'
import * as fs from 'fs'
import path from 'path'
import { ethers, AbstractProvider } from 'ethers'
import { exec } from 'child_process'

import * as C from './data/deployArgs';

dotenv.config({ path: path.resolve(__dirname, '../.env') });

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

async function getGasPrice(bump: bigint = 20n, provider: AbstractProvider): Promise<bigint> {
    if (bump < 1n) {
        throw new Error('gas price bump must be >= 1');
    }

    const price = (await provider.getFeeData()).gasPrice as bigint;
    return (price * bump / 100n + price);
}

async function deployProvider(provider: AbstractProvider, signer: ethers.Wallet, verifyContract: boolean = false) {
    let gasPrice = await getGasPrice(20n, provider)
    const { name, chainId } = await provider.getNetwork();
    const POLYGONSCAN_API_KEY: string = process.env.POLYGONSCAN_API_KEY as string
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
        await verifyContractUntilSuccess(addressTwap, nameTwap, chainId, POLYGONSCAN_API_KEY)
    }

    console.log('\n----- Deploying NormalizedPriceProvider contract -----\n');

    gasPrice = await getGasPrice(20n, provider)

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
        await verifyContractUntilSuccess(addressNpp, nameNpp, chainId, POLYGONSCAN_API_KEY)
    }

    console.log('\n----- Adding TwapV3 to NormalizedPriceProvider as oracle source -----\n');

    const contractNpp = new ethers.Contract(addressNpp, outNpp.abi, signer)
    const txn0x = await contractNpp.grantRole(C.PROVIDER_ADMIN_ROLE, signer.address)
    await txn0x.wait()
    await contractNpp.addOracleSource(addressTwap)

    console.log('----- TwapV3 added -----');
}

async function deployDimoCredit(provider: AbstractProvider, signer: ethers.Wallet, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n, provider)
    const { name, chainId } = await provider.getNetwork();

    const instances = getAddresses();

    const addressReceiver = instances[name].Receiver;
    const addressNpp = instances[name].NormalizedPriceProvider;

    console.log('\n----- Deploying DimoCredit contract -----\n');

    const nameDc = 'DimoCredit';
    const outDc = JSON.parse(fs.readFileSync(`./out/${nameDc}.sol/${nameDc}.json`, 'utf8'))
    const factoryDc = new ethers.ContractFactory(outDc.abi, outDc.bytecode.object, signer)
    const dimoCredit: ethers.BaseContract = await factoryDc.deploy(addressReceiver, addressNpp, { gasPrice: gasPrice })
    await dimoCredit.waitForDeployment()
    const addressDc = await dimoCredit.getAddress()
    console.log(`DimoCredit contract deployed to ${addressDc}`);

    instances[name].DimoCredit = addressDc;
    writeAddresses(instances, name)

    if (verifyContract) {
        const encodeArgsDc = factoryDc.interface.encodeDeploy([addressReceiver, addressNpp])
        const POLYGONSCAN_API_KEY: string = process.env.POLYGONSCAN_API_KEY as string
        await verifyContractUntilSuccess(addressDc, nameDc, chainId, POLYGONSCAN_API_KEY, encodeArgsDc)
    }
}

async function deployLicenseAccountFactory(provider: AbstractProvider, signer: ethers.Wallet, verifyContract: boolean = false) {
    const gasPrice = await getGasPrice(20n, provider)
    const { name, chainId } = await provider.getNetwork();
    const instances = getAddresses();

    console.log('\n----- Deploying LicenseAccountFactory contract -----\n');

    const nameLaf = 'LicenseAccountFactory';
    const outLaf = JSON.parse(fs.readFileSync(`./out/${nameLaf}.sol/${nameLaf}.json`, 'utf8'))
    const factoryLaf = new ethers.ContractFactory(outLaf.abi, outLaf.bytecode.object, signer)
    const licenseAccountFactory: ethers.BaseContract = await factoryLaf.deploy({ gasPrice: gasPrice })
    await licenseAccountFactory.waitForDeployment();
    const addressLaf = await licenseAccountFactory.getAddress();
    console.log(`LicenseAccountFactory contract deployed to ${addressLaf}`);

    instances[name].LicenseAccountFactory = addressLaf;
    writeAddresses(instances, name)

    if (verifyContract) {
        const POLYGONSCAN_API_KEY: string = process.env.POLYGONSCAN_API_KEY as string
        await verifyContractUntilSuccess(addressLaf, nameLaf, chainId, POLYGONSCAN_API_KEY)
    }
}

async function deployDevLicense(provider: AbstractProvider, signer: ethers.Wallet, verifyContract: boolean = false) {
    const instances = getAddresses();

    let gasPrice = await getGasPrice(20n, provider)
    const { name, chainId } = await provider.getNetwork();

    const addressReceiver = instances[name].Receiver;
    const addressLaf = instances[name].LicenseAccountFactory;
    const addressNpp = instances[name].NormalizedPriceProvider;
    const addressDimoToken = instances[name].DimoToken;
    const addressDc = instances[name].DimoCredit;
    const licenseCostInUsd = C.licenseCostInUsd;

    console.log('\n----- Deploying TwapV3 contract -----\n');

    const nameDl = 'DevLicenseDimo';
    const outDl = JSON.parse(fs.readFileSync(`./out/${nameDl}.sol/${nameDl}.json`, 'utf8'))
    const factoryDl = new ethers.ContractFactory(outDl.abi, outDl.bytecode.object, signer)
    const devLicense: ethers.BaseContract = await factoryDl.deploy(
        addressReceiver,
        addressLaf,
        addressNpp,
        addressDimoToken,
        addressDc,
        licenseCostInUsd,
        { gasPrice: gasPrice }
    )
    await devLicense.waitForDeployment();
    const addressDl = await devLicense.getAddress();
    console.log(`DevLicenseDimo contract deployed to ${addressDl}`);

    instances[name].DevLicenseDimo = addressDl;
    writeAddresses(instances, name)

    if (verifyContract) {
        const encodeArgsDl = factoryDl.interface.encodeDeploy([
            addressReceiver,
            addressLaf,
            addressNpp,
            addressDimoToken,
            addressDc,
            licenseCostInUsd
        ])
        const POLYGONSCAN_API_KEY: string = process.env.POLYGONSCAN_API_KEY as string
        await verifyContractUntilSuccess(addressDl, nameDl, chainId, POLYGONSCAN_API_KEY, encodeArgsDl)
    }

    console.log('\n----- Setting LicenseAccountFactory to DevLicenseDimo -----\n');

    const nameLaf = 'LicenseAccountFactory';
    const outLaf = JSON.parse(fs.readFileSync(`./out/${nameLaf}.sol/${nameLaf}.json`, 'utf8'))
    const contractLaf = new ethers.Contract(addressLaf, outLaf.abi, signer)
    await contractLaf.setLicense(addressDl)

    console.log('----- LicenseAccountFactory set -----');
}

async function verifyContractUntilSuccess(address: any, name: any, chainId: any, apiKey: any, arg?: any) {
    return new Promise((resolve, _) => {

        console.log(`\n----- Verifying ${name} contract at ${address} -----\n`);

        let command: string;
        if (!arg) {
            command = `forge verify-contract ${address} ${name} --chain-id ${chainId} --etherscan-api-key ${apiKey}`;
        } else {
            command = `forge verify-contract ${address} ${name} --chain-id ${chainId} --etherscan-api-key ${apiKey} --constructor-args ${arg}`;
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

function getNetwork(): string {
    let network: string;

    const args = process.argv.slice(2);
    const networkIndex = args.indexOf('--network');
    if (networkIndex !== -1 && networkIndex + 1 < args.length) {
        network = args[networkIndex + 1];
        if (!['polygon', 'amoy'].includes(network)) {
            throw new Error('Invalid --network specified');
        }
    } else {
        throw new Error('--network not specified');
    }

    return network;
}

function getProvider(network: string): AbstractProvider {
    let url: string;
    switch (network) {
        case 'polygon':
            url = process.env.POLYGON_URL as string;
            break;
        case 'amoy':
            url = process.env.AMOY_URL as string;
            break;
        default:
            throw Error('Invalid network');
    }

    return ethers.getDefaultProvider(url)
}

async function main() {
    const network = getNetwork();
    const provider = getProvider(network);

    const key: string = process.env.PRIVATE_KEY as string
    const wallet = new ethers.Wallet(key)
    const signer = wallet.connect(provider)

    await deployProvider(provider, signer);
    await deployDimoCredit(provider, signer);
    await deployLicenseAccountFactory(provider, signer);
    await deployDevLicense(provider, signer);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
}).finally(() => {
    process.exit();
});
