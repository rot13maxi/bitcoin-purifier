# Purify Your Node

Disgusting shitcoiners have exploited a bug in Bitcoin and are spewing their sinful scams all over Bitcoin. This repo contains a script that will reject blocks containing their scams. 

Either update the default parameters in the script to your preferred settings, or pass command line options as so:
```
 bash geld.sh -u user -p password -c main -P 8443
```

## Details

This script will reject blocks that contain a witness that includes the ordinals inscription envelope header. 

The script will also print out the blockhash of blocks it rejects.

If you change your mind and wish to include those blocks, run `bitcoin-cli reconsiderblock [blockhash]`