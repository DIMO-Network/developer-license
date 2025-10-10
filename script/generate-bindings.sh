
#!/bin/bash

# Exit on error
set -e

# Check if abigen is installed
if ! command -v abigen &> /dev/null
then
    echo "⚠️  abigen not found, skipping Go bindings generation"
    echo "To generate Go bindings, install abigen: https://geth.ethereum.org/docs/tools/abigen"
    exit 0
fi

echo "Generating Go bindings..."

# Create directories if they don't exist
mkdir -p bindings/DevLicenseDimo
mkdir -p bindings/DimoCredit

abigen --abi abis/DevLicenseDimo.json --out bindings/DevLicenseDimo/DevLicenseDimo.go --pkg devLicenseDimo --type DevLicenseDimo --v2
echo "✅ DevLicenseDimo bindings generated"

abigen --abi abis/DimoCredit.json --out bindings/DimoCredit/DimoCredit.go --pkg dimoCredit --type DimoCredit --v2
echo "✅ DimoCredit bindings generated"

echo "✅ All Go bindings generated successfully in bindings/"