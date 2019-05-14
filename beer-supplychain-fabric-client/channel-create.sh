#!/bin/bash

# Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# This bash shell script generates the configtx peer block, creates channel and join the peer node to the channel. 


# 1. Run the command to generate the configtx peer block:

echo generating the configtx peer block...
echo 
docker exec cli configtxgen -outputCreateChannelTx /opt/home/$CHANNEL.pb -profile OneOrgChannel -channelID $CHANNEL --configPath /opt/home/
echo 

# 2. Create the Channel

echo creating the channel...
echo 
docker exec -e "CORE_PEER_TLS_ENABLED=true" \
     -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
     -e "CORE_PEER_ADDRESS=$PEER" -e "CORE_PEER_LOCALMSPID=$MSP" \
     -e  "CORE_PEER_MSPCONFIGPATH=$MSP_PATH"   cli peer channel create -c $CHANNEL -f \
     /opt/home/$CHANNEL.pb -o $ORDERER --cafile $CAFILE --tls 
echo 


# 3. Join your peer node to the channel 

echo joining the peer node to the channel... 
echo 
docker exec -e "CORE_PEER_TLS_ENABLED=true" \
     -e "CORE_PEER_TLS_ROOTCERT_FILE=/opt/home/managedblockchain-tls-chain.pem" \
     -e "CORE_PEER_ADDRESS=$PEER" -e "CORE_PEER_LOCALMSPID=$MSP" \
     -e "CORE_PEER_MSPCONFIGPATH=$MSP_PATH"  cli peer channel join -b $CHANNEL.block -o \
     $ORDERER --cafile $CAFILE --tls 
echo 