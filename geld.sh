#!/usr/bin env bash

set -e -u -o pipefail

ord_fingerprint="0063036f7264"

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
    transactions=$(echo $block | jq -r '.tx[]')
    for transaction in $transactions; do
      # skip the coinbase
      if [ $transaction == $(echo $block | jq -r '.tx[0]') ]; then
        continue
      fi
      tx=$(bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost getrawtransaction $transaction 1)
      if [ $(echo $tx | jq -r '.vin[].txinwitness | length') -eq 0 ]; then
        continue
      fi
      vins=$(echo $tx | jq -r '.vin[]')
      echo $tx | jq -c '.vin[]' | while read -r vins; do
          txwitness=$(echo $vins | jq -r '.txinwitness[]')
          if [ ${#txwitness} -ge 2 ] && [[ $txwitness == *"$ord_fingerprint"* ]]; then
              echo "Shitcoining detected at block height $i! They lied to the code and must be punished! DEUS VULT!"
              echo "Block hash: $blockhash"
              bitcoin-cli -chain=$chain -rpcuser=$rpcuser -rpcpassword=$rpcpassword -rpcport=$rpcport -rpcconnect=$rpchost invalidateblock $blockhash
              break
          fi
      done
    done
      echo "done processing block $i"
      echo $i > lastblock.txt
  done

  echo "bitcoin never sleeps, but I do. sleeping for 60 seconds"
  sleepsixty=$(($(date +%s) + 60))
  while [ $(date +%s) -lt ${sleepsixty} ]; do
    if [ $(false) ]; then
      eval "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    fi;
  done

done
