import { ethers } from 'ethers'
import * as fs from 'fs'
import dotenv from 'dotenv'
import path from 'path'
import { exec } from 'child_process'

dotenv.config({ path: path.resolve(__dirname, '../.env') });

let url: string = process.env.POLYGON_MAINNET_RPC_URL as string
const provider = ethers.getDefaultProvider(url)

let key: string = process.env.PRIVATE_KEY as string
const wallet = new ethers.Wallet(key)
const signer = wallet.connect(provider)

async function main() {

    const gasPrice = (await provider.getFeeData()).gasPrice
    const chainId: number = parseInt(process.env.MAIN_CHAIN_ID as string)
    const etherscanApiKey: string = process.env.ETHERSCAN_API_KEY_POLYGON as string

    // ***************************
    // * ====== Oracle ========= *
    // ***************************

    const nameTwap = 'TwapV3'
    const outTwap = JSON.parse(fs.readFileSync(`./out/${nameTwap}.sol/${nameTwap}.json`, 'utf8')) 
    const setTwap = new ethers.ContractFactory(outTwap.abi, outTwap.bytecode.object, signer)
    const twap = await setTwap.deploy({gasPrice: gasPrice})
    await twap.waitForDeployment()
    const addressTwap = await twap.getAddress()
    console.log(`${nameTwap}: ` + addressTwap)
    await verifyContractUntilSuccess(addressTwap, nameTwap, chainId, etherscanApiKey)
    /* * */

    const nameNpp = 'NormalizedPriceProvider'
    const outNpp = JSON.parse(fs.readFileSync(`./out/${nameNpp}.sol/${nameNpp}.json`, 'utf8')) 
    const setNpp = new ethers.ContractFactory(outNpp.abi, outNpp.bytecode.object, signer)
    const normalizedPriceProvider = await setNpp.deploy({gasPrice: gasPrice})
    await normalizedPriceProvider.waitForDeployment()
    const addressNpp = await normalizedPriceProvider.getAddress()
    console.log(`${nameNpp}: ` + addressNpp);
    await verifyContractUntilSuccess(addressNpp, nameNpp, chainId, etherscanApiKey)
    /* * */
    const contractNpp = new ethers.Contract(addressNpp, outNpp.abi, signer)
    await contractNpp.addOracleSource(addressTwap);

    // ******************************************
    // * ====== TEST ONLY - REMOVE ME ========= *
    // ******************************************

    const nameMos = 'MockOracleSource'
    const outMos = JSON.parse(fs.readFileSync(`./out/${nameMos}.sol/${nameMos}.json`, 'utf8')) 
    const factoryMos = new ethers.ContractFactory(outMos.abi, outMos.bytecode.object, signer)
    const mockOracleSource: ethers.BaseContract = await factoryMos.deploy({gasPrice: gasPrice})
    await mockOracleSource.waitForDeployment()
    const addressMos = await mockOracleSource.getAddress()
    console.log(`${nameMos}: ` + addressMos)
    await verifyContractUntilSuccess(addressMos, nameMos, chainId, etherscanApiKey)
    /* * */
    const transaction = await contractNpp.addOracleSource(addressMos);
    await transaction.wait();
    const primaryOracleSourceIndex = 1;
    await contractNpp.setPrimaryOracleSource(primaryOracleSourceIndex);

    // ********************************
    // * ====== DIMO Credit ========= *
    // ********************************

    const addressReceiver = '0x2332A085461391595C3127472046EDC39996e141';

    const nameDc = 'DimoCredit';
    const outDc = JSON.parse(fs.readFileSync(`./out/${nameDc}.sol/${nameDc}.json`, 'utf8')) 
    const factoryDc = new ethers.ContractFactory(outDc.abi, outDc.bytecode.object, signer)
    const dimoCredit: ethers.BaseContract = await factoryDc.deploy(addressReceiver, addressNpp, {gasPrice: gasPrice})
    await dimoCredit.waitForDeployment()
    const addressDc = await dimoCredit.getAddress()
    console.log(`${nameDc}: ` + addressDc);
    let encodeArgsDc = factoryDc.interface.encodeDeploy([addressReceiver, addressNpp])
    await verifyContractUntilSuccess(addressDc, nameDc, chainId, etherscanApiKey, encodeArgsDc)

    // ********************************************
    // * ====== License Account Factory ========= *
    // ********************************************

    const nameLaf = 'LicenseAccountFactory';
    const outLaf = JSON.parse(fs.readFileSync(`./out/${nameLaf}.sol/${nameLaf}.json`, 'utf8')) 
    const factoryLaf = new ethers.ContractFactory(outLaf.abi, outLaf.bytecode.object, signer)
    const licenseAccountFactory: ethers.BaseContract = await factoryLaf.deploy({gasPrice: gasPrice})
    await licenseAccountFactory.waitForDeployment();
    const addressLaf = await licenseAccountFactory.getAddress();
    console.log(`${nameLaf}: ` + addressLaf);
    await verifyContractUntilSuccess(addressLaf, nameLaf, chainId, etherscanApiKey)


    // ******************************************
    // * ====== TEST ONLY - REMOVE ME ========= *
    // ******************************************

    const nameTt = 'TestToken'
    const outTt = JSON.parse(fs.readFileSync(`./out/${nameTt}.sol/${nameTt}.json`, 'utf8')) 
    const factoryTt = new ethers.ContractFactory(outTt.abi, outTt.bytecode.object, signer)
    const testToken: ethers.BaseContract = await factoryTt.deploy({gasPrice: gasPrice})
    await testToken.waitForDeployment()
    const addressTt = await testToken.getAddress()
    console.log(`${nameTt}: ` + addressTt)
    await verifyContractUntilSuccess(addressTt, nameTt, chainId, etherscanApiKey)

    // ********************************
    // * ====== Dev License ========= *
    // ********************************

    const licenseCostInUsd = 100;

    const nameDl = 'DevLicenseDimo';
    const outDl = JSON.parse(fs.readFileSync(`./out/${nameDl}.sol/${nameDl}.json`, 'utf8')) 
    const factoryDl = new ethers.ContractFactory(outDl.abi, outDl.bytecode.object, signer)
    const devLicense: ethers.BaseContract = await factoryDl.deploy(
        addressLaf,
        addressNpp,
        addressTt,
        addressDc,
        licenseCostInUsd,
        {
            maxPriorityFeePerGas: (await provider.getFeeData()).maxPriorityFeePerGas,
            maxFeePerGas: (await provider.getFeeData()).maxFeePerGas,
        }
    )
    await devLicense.waitForDeployment();
    const addressDl = await devLicense.getAddress();
    console.log(`${nameDl}: ` + addressDl);
    let encodeArgsDl = factoryDl.interface.encodeDeploy([
        addressLaf,
        addressNpp,
        addressTt,
        addressDc,
        licenseCostInUsd
    ])
    await verifyContractUntilSuccess(addressDl, nameDl, chainId, etherscanApiKey, encodeArgsDl)

    /* * */
    const contractLaf = new ethers.Contract(addressLaf, outLaf.abi, signer)
    await contractLaf.setLicense(addressDl)
    /* * */
    const contractTt = new ethers.Contract(addressTt, outTt.abi, signer)
    const value = 1000000000000000000000000n
    await contractTt.approve(addressDl, value)


    process.exit();
}



async function verifyContractUntilSuccess(address: any, name: any, chainId: any, apiKey: any, arg?: any) {
    return new Promise((resolve, _) => {

        let command: string;
        if(!arg) {
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
    
main();



