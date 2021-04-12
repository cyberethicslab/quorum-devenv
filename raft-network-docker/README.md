# quorum-devenv
Setting up a minimal Quorum network with Raft consensus for developing with Docker compose

## Reproducing from scratch


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
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "chainId": 10,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip158Block": 0,
    "maxCodeSizeConfig" : [
      {
        "block" : 0,
        "size" : 32
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

### 3. Create nodes crypto material
Inside *crypto/* directory run the following:
```
bootnode --genkey=nodekey1
bootnode --genkey=nodekey2
bootnode --genkey=nodekey3
```

### 4. Create *permissioned-nodes.json* file
```
[
  "enode://<EnodeID1>@127.0.0.1:21000?discport=0&raftport=50000",
  "enode://<EnodeID2>@127.0.0.1:21001?discport=0&raftport=50001",
  "enode://<EnodeID3>@127.0.0.1:21002?discport=0&raftport=50002"
]
```
Replace the <EnodeID> placeholder with the enode ID returned by the bootnode command:
```
bootnode --nodekey=nodekey1 --writeaddress
bootnode --nodekey=nodekey2 --writeaddress
bootnode --nodekey=nodekey3 --writeaddress
```