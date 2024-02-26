#!/bin/bash

# Check for command line argument
if [ $# -eq 0 ]; then
  echo "No network specified. Usage: $0 <network>"
  exit 1
fi

NETWORK=$1

# Load environment variables
set -a
source .env
set +a

# Determine RPC URL based on network argument
case $NETWORK in
  polygon)
    RPC_URL=$POLYGON_MAINNET_RPC_URL
    ;;
  mumbai)
    RPC_URL=$POLYGON_MUMBAI_RPC_URL
    ;;
  fuji)
    RPC_URL=$POLYGON_FUJI_RPC_URL
    ;;
  *)
    echo "Invalid network specified. Available options are: polygon, mumbai, fuji."
    exit 1
    ;;
esac

# Deploy using the appropriate RPC URL
forge create --rpc-url $RPC_URL --private-key $PRIVATE_KEY ./src/sources/FunctionsConsumer.sol:FunctionsConsumer --constructor-args-path ./constructor-args/constructor-args-$NETWORK.txt

# Flatten the source file and save to a directory
mkdir -p ./flat
forge flatten ./src/sources/FunctionsConsumer.sol > ./flat/FunctionsConsumer.txt

echo "Deployment and flattening for $NETWORK completed."
