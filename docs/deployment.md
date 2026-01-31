# Deployment Guide

## Prerequisites

- MetaMask wallet
- GenLayer testnet GEN tokens
- Static file hosting service (optional)

## Contract Deployment

### Option 1: GenLayer Studio (Recommended)

1. Visit [GenLayer Studio](https://studio.genlayer.com)

2. Click "New Contract"

3. Paste contents of `contracts/devscore.py` into the editor

4. Click "Deploy" to deploy the contract

5. Record the generated contract address

### Option 2: GenLayer CLI

```bash
# Install CLI
npm install -g genlayer-cli

# Configure account
genlayer account create --name default

# Deploy contract
genlayer deploy --contract contracts/devscore.py --rpc https://studio.genlayer.com/api

# Example output:
# Contract deployed at: 0x02bd9B7D953067500D9E4D5A78DC56e1965e083f
```

## Frontend Deployment

### Local Development

```bash
cd frontend
python3 -m http.server 8000
```

### Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel
```

### GitHub Pages

1. Push `frontend/index.html` to `gh-pages` branch

2. Enable in repository Settings > Pages

3. Access at `https://<username>.github.io/<repo>/`

### Netlify

1. Connect GitHub repository

2. Set Build command: (leave empty)

3. Set Publish directory: `frontend`

4. Deploy

## Configuration Update

After deployment, update frontend configuration:

```javascript
// frontend/index.html
const CONFIG = {
  chainId: 61999,
  chainIdHex: '0xf22f',
  rpcUrl: 'https://studio.genlayer.com/api',
  chainName: 'GenLayer Studio',
  contractAddress: '<YOUR_CONTRACT_ADDRESS>'  // Replace with actual address
};
```

## Verify Deployment

1. Open frontend page

2. Connect MetaMask

3. Enter test username (e.g., `torvalds`)

4. Click Analyze

5. Confirm transaction

6. Check transaction status in GenLayer Explorer

## Troubleshooting

### Contract Call Fails

- Check MetaMask is connected to GenLayer Studio network
- Confirm sufficient GEN balance
- Check Console for error messages

### Page Load Issues

- Clear browser cache
- Check CORS configuration
- Confirm ethers.js CDN is accessible

### Transaction Pending Too Long

- GenLayer AI consensus takes 30-60 seconds
- Check transaction status in Explorer
