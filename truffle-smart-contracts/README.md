# Deploying Smart Contracts on Quorum Network using Truffle

## Prerequisites
Install Truffle
```
npm install -g truffle
```

## Connecting Truffle to Quorum

### 1. Initialize Truffle project
```
truffle init
```

### 2. Configure Truffle to point to running Quorum client
Edit *development* network configuration inside *truffle-config.js* file
```
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 22000, // Node1
      network_id: "*", // Match any network id
      gasPrice: 0,
      gas: 4500000,
      type: "quorum" // needed for Truffle to support Quorum
    }
  }
};
```

## How to deploy
### 1. Create sample smart contract called SimpleStorage inside *contracts/* directory

### 2. Ensure the contract compiles running
```
truffle compile
```
This command creates a *build/contracts/* directory with compiled contracts

### 3. Create migration file for SimpleStorage
Next, create a new migration called 2_deploy_simplestorage.js within your *migrations/* directory with following content:
```
var SimpleStorage = artifacts.require("SimpleStorage");

module.exports = function(deployer) {
  // Pass 0 to the contract as the first constructor parameter
  deployer.deploy(SimpleStorage, 0)
};
```

### 4. Deploy contract
Run the following to deploy smart contracts
```
truffle migrate
```

#### 4.1. Solve *"authentication needed: password or unlock."*
Add *--allow-insecure-unlock* in start command to allow truffle migration.
Then attach to your node and run the following command:
```
web3.personal.unlockAccount(web3.personal.listAccounts[0]);
```