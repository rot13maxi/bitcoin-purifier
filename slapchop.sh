#!/usr/bin env bash

set -e -u -o pipefail

# default values
rpcuser="bitcoinrpc"
rpcpassword="password"
rpchost="localhost"
rpcport="8332"
startblock=1
chain="main"

while getopts ":u:p:h:P:s:c:" opt; do
  case $opt in
    u)
      rpcuser=$OPTARG
      ;;
    p)
      rpcpassword=$OPTARG
      ;;
    h)
      rpchost=$OPTARG
      ;;
    P)
      rpcport=$OPTARG
      ;;
    s)
      startblock=$OPTARG
      ;;
    c) 
      chain=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


if [ -f "lastblock.txt" ]; then
  lastblock=$(cat lastblock.txt)
else
  lastblock=$startblock
fi


while true; do

  blockheight=$(bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost getblockcount)

  for ((i=$lastblock; i<$blockheight; i++)); do
    blockhash=$(bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost getblockhash $i)
    block=$(bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost getblock $blockhash)
    blocksize=$(echo $block | jq -r '.size')
    if [ $blocksize -gt 300000 ]; then
      bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost invalidateblock $blockhash
      echo "THIS BLOCK IS TOO BIG! SLAPCHOP! $i"
      continue
    fi

    echo "done processing block $i"
    echo $i > lastblock.txt
  done

  echo "bitcoin never sleeps, but I do. sleeping for 60 seconds"
  sleep 60

done
