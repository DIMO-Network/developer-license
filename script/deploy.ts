import { ethers } from 'ethers'
import * as fs from 'fs'
import dotenv from 'dotenv'
import path from 'path'
import { exec } from 'child_process'
import util from 'util'

// Initialize dotenv
dotenv.config({ path: path.resolve(__dirname, '../.env') });

let url: string = process.env.POLYGON_MUMBAI_RPC_URL as string
const provider = ethers.getDefaultProvider(url)

let key: string = process.env.PRIVATE_KEY as string
const wallet = new ethers.Wallet(key)
const signer = wallet.connect(provider)

const execPromisify = util.promisify(exec);

async function verifyContract(chainId: number, etherscanApiKey: string, compilerVersion: string, contractAddress: string, name: string) {
    const command = `forge verify-contract --chain-id ${chainId} --etherscan-api-key ${etherscanApiKey} --compiler-version ${compilerVersion} ${contractAddress} ${name}`;
    try {
      const { stdout, stderr } = await execPromisify(command);
      console.log('stdout:', stdout);
      console.log('stderr:', stderr);
      if (stderr) {
        throw new Error('Verification failed, retrying...');
      }
      console.log('Verification successful!');
    } catch (error) {
      console.error('Error executing verification:', error);
      // Retry logic or fallback can be implemented here
    }
}

async function main() {

    const gasPrice = (await provider.getFeeData()).gasPrice
    const chainId: number = parseInt(process.env.CHAIN_ID as string)
    const etherscanApiKey: string = process.env.ETHERSCAN_API_KEY_POLYGON as string

    // ***************************
    // * ====== oracle ========= *
    // ***************************

    const nameTwap = 'TwapV3';
    const outTwap = JSON.parse(fs.readFileSync(`./out/${nameTwap}.sol/${nameTwap}.json`, 'utf8')) 
    const setTwap = new ethers.ContractFactory(outTwap.abi, outTwap.bytecode.object, signer);
    const twap = await setTwap.deploy({gasPrice: gasPrice});
    await twap.waitForDeployment();
    const addressTwap = await twap.getAddress();
    console.log("TwapV3: " + addressTwap);
    await verifyContract(chainId, etherscanApiKey, '0.8.22', addressTwap, nameTwap);
    /* * */
    const intervalUsdc: number = 1800
    const intervalDimo: number = 240
    const contractTwap = new ethers.Contract(addressTwap, outTwap.abi, signer);
    await contractTwap.initialize(intervalUsdc, intervalDimo);

    const nameNpp = 'NormalizedPriceProvider';
    const outNpp = JSON.parse(fs.readFileSync(`./out/${nameNpp}.sol/${nameNpp}.json`, 'utf8')) 
    const setNpp = new ethers.ContractFactory(outNpp.abi, outNpp.bytecode.object, signer);
    const normalizedPriceProvider = await setNpp.deploy({gasPrice: gasPrice});
    await normalizedPriceProvider.waitForDeployment();
    const addressNpp = await normalizedPriceProvider.getAddress();
    console.log("NormalizedPriceProvider: " + addressNpp);
    await verifyContract(chainId, etherscanApiKey, '0.8.22', addressNpp, nameNpp);
    /* * */
    const contractNpp = new ethers.Contract(addressNpp, outNpp.abi, signer);
    await contractNpp.addOracleSource(addressTwap);
    


    process.exit();
}
    
main();



