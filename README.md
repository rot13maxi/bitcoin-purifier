# Bitcoin Purifier

Bitcoin Purifier is a tool designed to protect your Bitcoin node from unwanted transactions that exploit certain features of the Bitcoin protocol. Specifically, it targets transactions related to "Ordinals" inscriptions which some consider to be a form of shitcoining.

## What It Does

The script monitors new blocks and rejects any block containing transactions with witnesses that include the Ordinals inscription envelope header. When such a block is detected, it will:

1. Print out the block hash
2. Invalidate the block using `bitcoin-cli invalidateblock`

If you change your mind later and want to reconsider a previously rejected block, you can use:
```
bitcoin-cli reconsiderblock [blockhash]
```

## Installation

1. Clone this repository:
   ```
   git clone https://github.com/rot13maxi/bitcoin-purifier.git
   cd bitcoin-purifier
   ```

2. Make the script executable:
   ```
   chmod +x geld.sh
   ```

## Usage

You can either update the default parameters in the script or pass command line options directly:

### Using Command Line Options
```
bash geld.sh -u your_rpc_user -p your_rpc_password -c main -P 8443
```

### Available Options:
- `-u` or `--rpcuser`: RPC username (default: bitcoinrpc)
- `-p` or `--rpcpassword`: RPC password (default: password)
- `-h` or `--rpchost`: RPC host (default: localhost)
- `-P` or `--rpcport`: RPC port (default: 8332)
- `-s` or `--startblock`: Starting block height to monitor (default: 1)
- `-c` or `--chain`: Chain name (main, test, etc.) (default: main)

## How It Works

The script continuously monitors new blocks and checks each transaction's witnesses for the Ordinals fingerprint. If it detects a match, it invalidates that block.

### Technical Details
- The script uses `bitcoin-cli` to interact with your Bitcoin node.
- It keeps track of the last processed block in `lastblock.txt`.
- It runs indefinitely, checking for new blocks every 60 seconds.

## Requirements

- A running Bitcoin node with RPC access enabled
- `jq` installed (for JSON processing)
- Bash shell

## License

This project is open source and available under the MIT License.