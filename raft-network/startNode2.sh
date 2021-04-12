#!/bin/bash
cd node2
PRIVATE_CONFIG=ignore geth --datadir data --nodiscover --verbosity 5 --networkid 31337 --raft --raftport 50001 --http --http.addr 0.0.0.0 --http.port 22001 --http.api admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints --port 21001 --allow-insecure-unlock