# quorum-devenv
Setting up a minimal Quorum network with Raft consensus for developing using Docker

## Prerequisites
Ensure that PATH contains *geth* and *bootnode*.
```
git clone https://github.com/ConsenSys/quorum.git
cd quorum
make all
```
Add $REPO_ROOT/build/bin to your PATH.
To test installation run
```
make test
```

## Reproducing from scratch
### 1. Create directories
raft-network \
├── node1\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── data\
├── node2\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├── data

### 2. Create genesis file inside root directory
Create raftGenesis.json file with the following content:
```
{
  "alloc": {
    "0xed9d02e382b34818e88b88a309c7fe71e65f419d": {
      "balance": "1000000000000000000000000000"
    },
    "0xca843569e3427144cead5e4d5999a3d0ccf92b8e": {
      "balance": "1000000000000000000000000000"
    },
    "0x0fbdc686b912d7722dc86510934589e0aaf3b55a": {
      "balance": "1000000000000000000000000000"
    },
    "0x9186eb3d20cbd1f5f992a950d808c4495153abd5": {
      "balance": "1000000000000000000000000000"
    },
    "0x0638e1574728b6d862dd5d3a3e0942c3be47d996": {
      "balance": "1000000000000000000000000000"
    }
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "config": {
    "homesteadBlock": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "chainId": 10,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip158Block": 0,
    "maxCodeSizeConfig": [
      {
        "block": 0,
        "size": 35
      }
    ],
    "isQuorum": true
  },
  "difficulty": "0x0",
  "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0xE0000000",
  "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
```

### 3. Create crypto material for nodes
- Generate node key
```
cd node1
bootnode --genkey=nodekey
cp nodekey data/
```
```
cd node2
bootnode --genkey=nodekey
cp nodekey data/
```
- Display enodeIDs
```
cd node1
bootnode --nodekey=nodekey --writeaddress
```
```
cd node2
bootnode --nodekey=nodekey --writeaddress
```
- Create *static-nodes.json* file inside data dir with the following content
```
[
  "enode://<EnodeID1>@127.0.0.1:21000?discport=0&raftport=50000",
  "enode://<EnodeID2>@127.0.0.1:21001?discport=0&raftport=50001"
]
```
- Replace the <EnodeID> placeholder with the enode ID returned by the bootnode command

### 4. Initialize nodes
```
cd node1
geth --datadir data init ../raftGenesis.json
```
```
cd node2
geth --datadir data init ../raftGenesis.json
```

### 5. Start node1
From node1 directory run
```
PRIVATE_CONFIG=ignore geth --datadir data --nodiscover --verbosity 5 --networkid 31337 --raft --raftport 50000 --http --http.addr 0.0.0.0 --http.port 22000 --http.api admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints --port 21000
```

### 6. Start node2
From node2 directory run
```
PRIVATE_CONFIG=ignore geth --datadir data --nodiscover --verbosity 5 --networkid 31337 --raft --raftport 50001 --http --http.addr 0.0.0.0 --http.port 22001 --http.api admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints --port 21001
```

### 7. Attach to a node
From noden directory run
```
geth attach data/geth.ipc
```

### 8. Verify connection
Run the following to check that nodes are correctly connected
```
raft.cluster
```
Output should be something like that
```
[{
    hostname: "127.0.0.1",
    nodeActive: true,
    nodeId: "40959e63c64d7bb5f46cc2659729e9c267c35b46aad59ade346452cc11748f769cd31b2524e5ed58af856dc993acacd367dec1d9fb017528184669cdae0ed665",
    p2pPort: 21000,
    raftId: 1,
    raftPort: 50000,
    role: "minter"
}, {
    hostname: "127.0.0.1",
    nodeActive: true,
    nodeId: "82bd73a93fc2c4be643035f569adb3f790be8b5476ed2d400ca6dfd9a5feb4e49abf85d460a3ea9203d80943290fd55d4a5e83bb6a6023bb7d779be3413c2710",
    p2pPort: 21001,
    raftId: 2,
    raftPort: 50001,
    role: "verifier"
}]
```