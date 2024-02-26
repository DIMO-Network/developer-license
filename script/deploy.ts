// SPDX-License-Identifier: AGPL-3.0
import { ethers } from 'ethers'
import * as fs from 'fs'
import 'dotenv/config'

// ********************************************
// * ====== DittoPoolFactory params ========= *
// ********************************************
const protocolFeeMultiplier = "100000000000000000";
const protocolFeeRecipient = "0x18181a21BB74A9De56d1Fbd408c4FeC175Ca0b16";


const provider = new ethers.providers.WebSocketProvider(process.env.rpcUrlWebSocket);
const wallet = new ethers.Wallet(process.env.privateKey);
const signer = wallet.connect(provider);


async function main() {

    // ************************
    // * ====== xyk ========= *
    // ************************

    const outDittoPoolXyk = JSON.parse(fs.readFileSync('./out/DittoPoolXyk.sol/DittoPoolXyk.json', 'utf8')) 
    const setDittoPoolXyk = new ethers.ContractFactory(outDittoPoolXyk.abi, outDittoPoolXyk.bytecode.object, signer);
    const dittoPoolXyk = await setDittoPoolXyk.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolXyk.deployed();
    const addressDittoPoolXyk = dittoPoolXyk.address;
    console.log("DittoPoolXyk: " + addressDittoPoolXyk);

    // ************************
    // * ====== exp ========= *
    // ************************

    const outDittoPoolExp = JSON.parse(fs.readFileSync('./out/DittoPoolExp.sol/DittoPoolExp.json', 'utf8')) 
    const setDittoPoolExp = new ethers.ContractFactory(outDittoPoolExp.abi, outDittoPoolExp.bytecode.object, signer);
    const dittoPoolExp = await setDittoPoolExp.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolExp.deployed();
    const addressDittoPoolExp = dittoPoolExp.address;
    console.log("DittoPoolExp: " + addressDittoPoolExp);

    const outDittoPoolExpBuy = JSON.parse(fs.readFileSync('./out/DittoPoolExpBuy.sol/DittoPoolExpBuy.json', 'utf8')) 
    const setDittoPoolExpBuy = new ethers.ContractFactory(outDittoPoolExpBuy.abi, outDittoPoolExpBuy.bytecode.object, signer);
    const dittoPoolExpBuy = await setDittoPoolExpBuy.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolExpBuy.deployed();
    const addressDittoPoolExpBuy = dittoPoolExpBuy.address;
    console.log("DittoPoolExpBuy: " + addressDittoPoolExpBuy);

    const outDittoPoolExpSell = JSON.parse(fs.readFileSync('./out/DittoPoolExpSell.sol/DittoPoolExpSell.json', 'utf8')) 
    const setDittoPoolExpSell = new ethers.ContractFactory(outDittoPoolExpSell.abi, outDittoPoolExpSell.bytecode.object, signer);
    const dittoPoolExpSell = await setDittoPoolExpSell.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolExpSell.deployed();
    const addressDittoPoolExpSell = dittoPoolExpSell.address;
    console.log("DittoPoolExpSell: " + addressDittoPoolExpSell);

    // ***************************
    // * ====== linear ========= *
    // ***************************

    const outDittoPoolLinear = JSON.parse(fs.readFileSync('./out/DittoPoolLinear.sol/DittoPoolLinear.json', 'utf8')) 
    const setDittoPoolLinear = new ethers.ContractFactory(outDittoPoolLinear.abi, outDittoPoolLinear.bytecode.object, signer);
    const dittoPoolLinear = await setDittoPoolLinear.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolLinear.deployed();
    const addressDittoPoolLinear = dittoPoolLinear.address;
    console.log("DittoPoolLinear: " + addressDittoPoolLinear);

    const outDittoPoolLinearBuy = JSON.parse(fs.readFileSync('./out/DittoPoolLinearBuy.sol/DittoPoolLinearBuy.json', 'utf8')) 
    const setDittoPoolLinearBuy = new ethers.ContractFactory(outDittoPoolLinearBuy.abi, outDittoPoolLinearBuy.bytecode.object, signer);
    const dittoPoolLinearBuy = await setDittoPoolLinearBuy.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolLinearBuy.deployed();
    const addressDittoPoolLinearBuy = dittoPoolLinearBuy.address;
    console.log("DittoPoolLinearBuy: " + addressDittoPoolLinearBuy);

    const outDittoPoolLinearSell = JSON.parse(fs.readFileSync('./out/DittoPoolLinearSell.sol/DittoPoolLinearSell.json', 'utf8')) 
    const setDittoPoolLinearSell = new ethers.ContractFactory(outDittoPoolLinearSell.abi, outDittoPoolLinearSell.bytecode.object, signer);
    const dittoPoolLinearSell = await setDittoPoolLinearSell.deploy({gasPrice: await provider.getGasPrice()});
    await dittoPoolLinearSell.deployed();
    const addressDittoPoolLinearSell = dittoPoolLinearSell.address;
    console.log("DittoPoolLinearSell: " + addressDittoPoolLinearSell);

    /* * */

    const outDittoPoolFactory = JSON.parse(fs.readFileSync('./out/DittoPoolFactory.sol/DittoPoolFactory.json', 'utf8')) 
    const setDittoPoolFactory = new ethers.ContractFactory(outDittoPoolFactory.abi, outDittoPoolFactory.bytecode.object, signer);
    const dittoPoolFactory = await setDittoPoolFactory.deploy(protocolFeeRecipient, protocolFeeMultiplier, {gasPrice: await provider.getGasPrice()});
    await dittoPoolFactory.deployed();
    console.log("DittoPoolFactory: " + dittoPoolFactory.address);

    const poolTemplate = [
        addressDittoPoolXyk,        // 0 
        addressDittoPoolExp,        // 1
        addressDittoPoolExpBuy,     // 2
        addressDittoPoolExpSell,    // 3
        addressDittoPoolLinear,     // 4
        addressDittoPoolLinearBuy,  // 5
        addressDittoPoolLinearSell  // 6
    ];

    console.log("setPoolTemplate");
    const setPoolTemplate = await dittoPoolFactory.setPoolTemplate(poolTemplate, {gasPrice: await provider.getGasPrice()});
    await setPoolTemplate.wait();
    console.log("✅");

    process.exit();
}
    
main();



