import { ethers } from 'ethers'
import * as fs from 'fs'
import dotenv from 'dotenv'
import path from 'path'
import { exec } from 'child_process'
import util from 'util'

dotenv.config({ path: path.resolve(__dirname, '../.env') });

let url: string = process.env.POLYGON_MUMBAI_RPC_URL as string
const provider = ethers.getDefaultProvider(url)

let key: string = process.env.PRIVATE_KEY as string
const wallet = new ethers.Wallet(key)
const signer = wallet.connect(provider)

async function main() {

    const gasPrice = (await provider.getFeeData()).gasPrice
    const chainId: number = parseInt(process.env.CHAIN_ID as string)
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
    //await verifyContract(chainId, etherscanApiKey, '0.8.22', addressTwap, nameTwap)
    await verifyContractUntilSuccess(addressTwap, nameTwap, chainId, etherscanApiKey)
    /* * */
    const intervalUsdc: number = 1800
    const intervalDimo: number = 240
    const contractTwap = new ethers.Contract(addressTwap, outTwap.abi, signer)
    await contractTwap.initialize(intervalUsdc, intervalDimo)

    const nameNpp = 'NormalizedPriceProvider'
    const outNpp = JSON.parse(fs.readFileSync(`./out/${nameNpp}.sol/${nameNpp}.json`, 'utf8')) 
    const setNpp = new ethers.ContractFactory(outNpp.abi, outNpp.bytecode.object, signer)
    const normalizedPriceProvider = await setNpp.deploy({gasPrice: gasPrice})
    await normalizedPriceProvider.waitForDeployment()
    const addressNpp = await normalizedPriceProvider.getAddress()
    console.log(`${nameNpp}: ` + addressNpp);
    //await verifyContract(chainId, etherscanApiKey, '0.8.22', addressNpp, nameNpp)
    await verifyContractUntilSuccess(addressNpp, nameNpp, chainId, etherscanApiKey)
    /* * */
    const contractNpp = new ethers.Contract(addressNpp, outNpp.abi, signer)
    await contractNpp.addOracleSource(addressTwap);

    // ********************************
    // * ====== DIMO Credit ========= *
    // ********************************

    const addressReceiver = '0x2332A085461391595C3127472046EDC39996e141';

    const nameDc = 'DimoCredit';
    const outDc = JSON.parse(fs.readFileSync(`./out/${nameDc}.sol/${nameDc}.json`, 'utf8')) 
    const factoryDc = new ethers.ContractFactory(outDc.abi, outDc.bytecode.object, signer);
    const dimoCredit: ethers.BaseContract = await factoryDc.deploy(addressReceiver, addressNpp, {gasPrice: gasPrice});
    await dimoCredit.waitForDeployment();
    const addressDc = await dimoCredit.getAddress();
    console.log(`${nameDc}: ` + addressDc);
    let encodeArgsDc = factoryDc.interface.encodeDeploy([addressReceiver, addressNpp])
    await verifyContractUntilSuccess(addressDc, nameDc, chainId, etherscanApiKey, encodeArgsDc)
    /* * */

    process.exit();
}

// const execPromisify = util.promisify(exec);
// async function verifyContract(chainId: number, etherscanApiKey: string, compilerVersion: string, contractAddress: string, name: string) {
//     const command = `forge verify-contract --chain-id ${chainId} --etherscan-api-key ${etherscanApiKey} --compiler-version ${compilerVersion} ${contractAddress} ${name}`;
//     try {
//       const { stdout, stderr } = await execPromisify(command);
//       console.log('stdout:', stdout);
//       console.log('stderr:', stderr);
//       if (stderr) {
//         throw new Error('Verification failed, retrying...');
//       }
//       console.log('Verification successful!');
//     } catch (error) {
//       console.error('Error executing verification:', error);
//       // Retry logic or fallback can be implemented here
//     }
// }

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



