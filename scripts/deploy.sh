#!/bin/bash

# DevScore Deployment Script

set -e

echo "=========================================="
echo "  DevScore Deployment"
echo "=========================================="

# Check if genlayer CLI is installed
if ! command -v genlayer &> /dev/null; then
    echo "Error: genlayer CLI not found"
    echo "Install with: npm install -g genlayer-cli"
    exit 1
fi

# Deploy contract
echo ""
echo "[1/3] Deploying contract..."
CONTRACT_ADDRESS=$(genlayer deploy \
    --contract contracts/devscore.py \
    --rpc https://studio.genlayer.com/api \
    2>&1 | grep -oP '0x[a-fA-F0-9]{40}')

if [ -z "$CONTRACT_ADDRESS" ]; then
    echo "Error: Failed to deploy contract"
    exit 1
fi

echo "Contract deployed at: $CONTRACT_ADDRESS"

# Update frontend config
echo ""
echo "[2/3] Updating frontend config..."
sed -i "s/contractAddress: '0x[a-fA-F0-9]*'/contractAddress: '$CONTRACT_ADDRESS'/" frontend/index.html

echo "Frontend config updated"

# Verify
echo ""
echo "[3/3] Verifying deployment..."
echo "Contract: $CONTRACT_ADDRESS"
echo "Network: GenLayer Studio (Chain ID: 61999)"

echo ""
echo "=========================================="
echo "  Deployment Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. cd frontend && python3 -m http.server 8000"
echo "2. Open http://localhost:8000"
echo "3. Connect MetaMask and test"
