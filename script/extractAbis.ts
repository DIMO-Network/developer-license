import * as fs from 'fs';
import path from 'path';

async function extractAbis(contracts: string[]) {
    const outDir = path.join(__dirname, '..', 'out');
    const abiDir = path.join(__dirname, '..', 'abis');

    // Create abi directory if it doesn't exist
    if (!fs.existsSync(abiDir)) {
        fs.mkdirSync(abiDir);
    }

    // Walk through the out directory
    const allContracts = walkSync(outDir);
    console.log(`Found ${allContracts.length} JSON files in the out directory`);

    let extractedCount = 0;

    for (const contractPath of allContracts) {
        if (contractPath.endsWith('.json')) {
            try {
                const pathParts = contractPath.split(path.sep);
                const contractName = pathParts[pathParts.length - 1].replace('.json', '');

                // Only process if the contract is in our target list
                if (contracts.includes(contractName)) {
                    const contractJson = JSON.parse(fs.readFileSync(contractPath, 'utf8'));

                    if (contractJson.abi) {
                        // Write ABI to file
                        fs.writeFileSync(
                            path.join(abiDir, `${contractName}.json`),
                            JSON.stringify(contractJson.abi, null, 2)
                        );

                        console.log(`Extracted ABI for ${contractName}`);
                        extractedCount++;
                    } else {
                        console.log(`No ABI found for ${contractName}`);
                    }
                }
            } catch (error) {
                console.error(`Error processing ${contractPath}:`, error);
            }
        }
    }

    console.log(`ABI extraction complete! Extracted ${extractedCount} ABIs from target contracts.`);
}

function walkSync(dir: string, filelist: string[] = []): string[] {
    const files = fs.readdirSync(dir);

    files.forEach(file => {
        const filepath = path.join(dir, file);
        if (fs.statSync(filepath).isDirectory()) {
            filelist = walkSync(filepath, filelist);
        } else {
            filelist.push(filepath);
        }
    });

    return filelist;
}

extractAbis([
    'DimoCredit',
    'DevLicenseDimo',
    'DimoDeveloperLicenseAccount',
    'LicenseAccountFactory',
    'NormalizedPriceProvider',
    'TwapV3'
]).catch(console.error);