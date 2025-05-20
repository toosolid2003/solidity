# Ethereum Vault

A secure, owner-controlled ETH vault smart contract built on Ethereum.

## Overview

This project implements a simple but secure Ethereum vault that allows users to deposit ETH and permits only the vault owner to withdraw the funds. It's designed with security best practices in mind and tested to ensure reliable operation.

## Features

- **Secure Deposits**: Anyone can deposit ETH to the vault
- **Owner-Only Withdrawals**: Only the designated owner can withdraw funds
- **Security Mechanisms**: Includes reentrancy protection and emergency pause functionality
- **Ownership Management**: Supports secure ownership transfer
- **Event Logging**: Emits events for deposits and withdrawals for off-chain tracking

## Contract Functions

### Core Functions

- `deposit()`: Allows users to deposit ETH into the vault
- `withdraw()`: Allows the owner to withdraw all ETH from the vault
- `checkBalance()`: Returns the current balance of the vault

<!-- ### Administrative Functions

- `transferOwnership(address newOwner)`: Transfers vault ownership to a new address
- `pause()`: Pauses the contract, preventing new deposits
- `unpause()`: Unpauses the contract, allowing deposits again -->

## Security Considerations

The vault contract implements several security measures:

- **Reentrancy Protection**: Using OpenZeppelin's ReentrancyGuard
- **Ownership Controls**: Strict validation of owner-only functions
<!-- - **Input Validation**: Checking for zero values and invalid addresses -->
- **Circuit Breaker**: Emergency pause functionality to stop operations if needed
- **Events**: Detailed event logging for off-chain monitoring

## Local Development

### Prerequisites

- Node.js (v16+)
- npm or yarn
- Hardhat

### Setup

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/ethereum-vault.git
   cd ethereum-vault
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Compile contracts:
   ```
   npx hardhat compile
   ```

4. Run tests:
   ```
   npx hardhat test
   ```

### Running Tests

The project includes a comprehensive test suite that covers:

- Basic deposit and withdrawal functionality
- Owner-only access controls
- Security edge cases
- Reentrancy attack prevention

Run the full test suite with:

```
npx hardhat test
```

## Deployment

### Local Testing Deployment

```
npx hardhat run scripts/deploy.js --network localhost
```

### Testnet Deployment

1. Set up your environment variables:
   ```
   cp .env.example .env
   ```

2. Edit `.env` with your private key and network API keys

3. Deploy to a testnet (e.g., Goerli):
   ```
   npx hardhat run scripts/deploy.js --network goerli
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This code is provided as an educational example and should undergo professional audit before any production use.