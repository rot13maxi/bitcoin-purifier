# Tools to Purify Your Node

## Common Options
- `-u` RPC User
- `-p` RPC Password
- `-h` RPC Host
- `-P` RPC port
- `-s` start block - the script will not start rejecting blocks before this height. Use this to coo-rdinate the economic majority of the network turning on the tool
- `-c` chain (for testing on signet, etc)


## Geld - Remove Inscriptions

Disgusting shitcoiners have exploited a bug in Bitcoin and are spewing their sinful scams all over Bitcoin. This repo contains a script that will reject blocks containing their scams. 

Either update the default parameters in the script to your preferred settings, or pass command line options as so:
```sh
 bash geld.sh -u user -p password -c main -P 8443
```
This script will reject blocks that contain a witness that includes the ordinals inscription envelope header. 

The script will also print out the blockhash of blocks it rejects.

If you change your mind and wish to include those blocks, run `bitcoin-cli reconsiderblock [blockhash]`


## Slapchop - right-size your blocks

Those scammers just won't stop. They're taking advantage of the generosity of our blocksize to cram in MORE SPAM. `slapchop.sh` is a script that will reject any block larger than 300kb. 

The script will also print out the blockhash of blocks it rejects.

If you change your mind and wish to include those blocks, run `bitcoin-cli reconsiderblock [blockhash]`

Either update the default parameters in the script to your preferred settings, or pass command line options as so:
```sh
 bash slapchop.sh -u user -p password -c main -P 8443
```

