# DevScore

A decentralized GitHub developer reputation scoring system built on GenLayer blockchain.
"My goal was to leverage GenLayer's unique ability to 'see' the web and 'think' via AI. This DApp provides a trustless layer for project owners to verify their community members' real technical influence."

## Overview

DevScore is a decentralized developer reputation platform that leverages GenLayer's AI-powered smart contracts to analyze GitHub profiles and generate reputation scores. Scores are determined through consensus among multiple AI validators (GPT-4, Gemini, Grok, etc.) and permanently stored on-chain, ensuring fairness and immutability.

### Key Features

- **AI Consensus Scoring**: 5 independent AI validator nodes analyze GitHub data and reach consensus on final scores
- **On-chain Storage**: All reputation scores are permanently stored on the GenLayer blockchain
- **Multi-dimensional Analysis**: Comprehensive evaluation of code contributions, community influence, and development activity
- **Real-time Preview**: Frontend instantly displays local scores based on GitHub API while on-chain verification proceeds

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   HTML/CSS  │  │  ethers.js  │  │    GitHub API       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      MetaMask                                │
│            (Transaction Signing & Network)                   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   GenLayer Network                           │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              DevScore Smart Contract                 │    │
│  │  ┌───────────┐  ┌───────────┐  ┌───────────────┐   │    │
│  │  │ Web Fetch │  │ AI Prompt │  │ Score Storage │   │    │
│  │  └───────────┘  └───────────┘  └───────────────┘   │    │
│  └─────────────────────────────────────────────────────┘    │
│                              │                               │
│                              ▼                               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              AI Validator Consensus                  │    │
│  │  ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ │    │
│  │  │GPT-4  │ │Gemini │ │ Grok  │ │Claude │ │ Qwen  │ │    │
│  │  └───────┘ └───────┘ └───────┘ └───────┘ └───────┘ │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

## Scoring System

### Grade Classification

| Grade | Score Range | Description |
|-------|-------------|-------------|
| A | 90-100 | Top-tier influence, renowned open source contributor |
| B | 70-89 | Active developer with notable community presence |
| C | 50-69 | Consistently active, steady contributor |
| D | 30-49 | Beginner, building open source footprint |
| E | 0-29 | Low activity level |

### Evaluation Dimensions

1. **Repository Quality** - Code standards, documentation, test coverage
2. **Activity Level** - Commit frequency, issue handling, PR merges
3. **Community Impact** - Stars, forks, followers
4. **Technical Skills** - Programming languages, technology stack breadth

## Project Structure

```
devscore/
├── contracts/
│   └── devscore.py          # GenLayer smart contract
├── frontend/
│   └── index.html           # Frontend single-page application
├── docs/
│   ├── api.md               # API documentation
│   └── deployment.md        # Deployment guide
├── scripts/
│   └── deploy.sh            # Deployment script
├── .gitignore
├── LICENSE
└── README.md
```

## Quick Start

### Prerequisites

- MetaMask browser extension
- That's it - no tokens or balance required

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/user/devscore.git
cd devscore
```

2. **Configure MetaMask**

Add GenLayer testnet:
- Network Name: GenLayer Studio
- RPC URL: https://studio.genlayer.com/api
- Chain ID: 61999
- Currency Symbol: GEN

3. **Start frontend**

```bash
cd frontend
python3 -m http.server 8000
# Or use any static server
npx serve .
```

4. **Access the application**

Open browser and navigate to `http://localhost:8000`

## Smart Contract

### Contract Address

- **Testnet**: `0x02bd9B7D953067500D9E4D5A78DC56e1965e083f`

### Contract Methods

#### generate_report(github_handle: str) -> str

Generate a reputation report for a GitHub user.

**Parameters:**
- `github_handle`: GitHub username

**Returns:**
```json
{
  "score": 85,
  "grade": "B",
  "summary": "Active developer with multiple high-quality open source projects"
}
```

**Gas Cost:** Free (no GEN deducted)

#### get_score(github_handle: str) -> str

Retrieve stored score for a GitHub user.

**Parameters:**
- `github_handle`: GitHub username

**Returns:** JSON score data, or empty string if not found

### Deploy New Contract

```bash
# Using GenLayer CLI
genlayer deploy --contract contracts/devscore.py --rpc https://studio.genlayer.com/api
```

## Frontend Integration

### Configuration

```javascript
const CONFIG = {
  chainId: 61999,
  chainIdHex: '0xf22f',
  rpcUrl: 'https://studio.genlayer.com/api',
  chainName: 'GenLayer Studio',
  contractAddress: '0x02bd9B7D953067500D9E4D5A78DC56e1965e083f'
};
```

### Flow

1. User connects MetaMask wallet
2. Enter GitHub username and click analyze
3. MetaMask prompts for transaction confirmation
4. Transaction submitted to GenLayer network
5. AI validators execute analysis and reach consensus
6. Frontend displays score results

### Error Handling

| Error Type | Cause | Solution |
|------------|-------|----------|
| duplicate key | User already analyzed | Display local score instead |
| user rejected | User cancelled MetaMask prompt | Try again |

## API Reference

### GitHub API Integration

Frontend uses GitHub REST API to fetch public user data:

```javascript
// Get user info
GET https://api.github.com/users/{username}

// Get user repositories
GET https://api.github.com/users/{username}/repos?per_page=100&sort=updated
```

### Local Scoring Algorithm

```javascript
// Base score
let score = 5;

// Follower bonus
if (followers >= 10000) score += 35;
else if (followers >= 1000) score += 25;
else if (followers >= 100) score += 15;

// Total stars bonus
if (totalStars >= 10000) score += 35;
else if (totalStars >= 1000) score += 25;
else if (totalStars >= 100) score += 15;

// Repository count bonus
if (publicRepos >= 50) score += 15;
else if (publicRepos >= 20) score += 10;
```

## Development

### Local Development

```bash
# Start local server
cd frontend
python3 -m http.server 8000

# Edit code and refresh browser to see changes
```

### Contract Debugging

1. Visit [GenLayer Studio](https://studio.genlayer.com)
2. Upload contract code
3. Test using Simulation Mode
4. Switch to Normal Mode for real deployment

### Code Standards

- Contract code follows PEP 8 conventions
- Frontend uses ES6+ syntax
- Commit messages follow semantic format

## Deployment

### Testnet Deployment

```bash
# 1. Deploy contract
genlayer deploy --contract contracts/devscore.py

# 2. Note the contract address
# 3. Update contractAddress in frontend config
# 4. Deploy frontend to static hosting service
```

### Mainnet Deployment

> Before mainnet deployment ensure:
> - Contract code thoroughly tested
> - Security audit completed

## FAQ

**Why can I only analyze a user once?**

Contract uses a TreeMap with the username as key, so each handle can only be written once. If you want to re-score someone, deploy a fresh contract instance.

**Do I need to pay GEN?**

No. Calling the contract doesn't actually cost GEN - you just need to have MetaMask switched to the GenLayer Studio network and confirm the transaction. No tokens are deducted.

**Analysis seems slow?**

On-chain AI consensus runs across multiple validators, takes roughly 30-60 seconds. The frontend shows you a local score right away so you're not staring at a spinner.

**How do I switch to GenLayer Studio network?**

The app handles it automatically - when you click Connect MetaMask, it'll prompt you to add/switch to GenLayer Studio (Chain ID: 61999). Just approve the network switch.

**Where do I get a wallet?**

Install [MetaMask](https://metamask.io), create a wallet, then connect to the app. That's it - no tokens needed.

## Contributing

Issues and Pull Requests welcome!

1. Fork the project
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'feat: add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Create Pull Request

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- [GenLayer](https://genlayer.com) - AI smart contract platform
- [ethers.js](https://ethers.org) - Ethereum JavaScript library
- [GitHub API](https://docs.github.com/en/rest) - Developer data interface

---

**DevScore** - Putting Developer Reputation On-Chain
