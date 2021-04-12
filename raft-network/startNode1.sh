#!/bin/bash
cd node1
PRIVATE_CONFIG=ignore geth --datadir data --nodiscover --verbosity 5 --networkid 31337 --raft --raftport 50000 --http --http.addr 0.0.0.0 --http.port 22000 --http.api admin,eth,debug,miner,net,txpool,personal,web3,quorum,raft --emitcheckpoints --port 21000 --allow-insecure-unlock