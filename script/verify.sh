#!/bin/bash

# Check if both a network and contract address were passed as arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <network> <contract-address>"
  exit 1
fi

NETWORK="$1"
CONTRACT_ADDRESS="$2"

# Load the .env file
set -a
source .env
set +a

# Determine the correct Etherscan API key and chain ID based on the network
case $NETWORK in
  polygon)
    ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY_POLYGON
    CHAIN_ID=137 # Replace with Polygon mainnet chain ID if different
    ;;
  mumbai)
    ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY_POLYGON
    CHAIN_ID=80001 # Replace with Mumbai testnet chain ID if different
    ;;
  fuji)
    ETHERSCAN_API_KEY=$ETHERSCAN_API_KEY_FUJI
    CHAIN_ID=43113 # Replace with the correct Fuji testnet chain ID
    ;;
  *)
    echo "Invalid network specified. Available options are: polygon, mumbai, fuji."
    exit 1
    ;;
esac

# Verify the contract on the specified network with Etherscan
forge verify-contract --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY --compiler-version v0.8.19 $CONTRACT_ADDRESS FunctionsConsumer

echo "Contract verification for $NETWORK initiated."
