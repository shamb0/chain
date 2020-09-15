![Nodle Banner](https://user-images.githubusercontent.com/10683430/80538204-2a6bef00-895a-11ea-94eb-2203ef6fae09.jpg)

# Nodle Chain ![Security audit](https://github.com/NodleCode/chain/workflows/Security%20audit/badge.svg) ![Test rust code](https://github.com/NodleCode/chain/workflows/Test%20rust%20code/badge.svg) [![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=NodleCode/chain)](https://dependabot.com)

This repo contains the code to run a Nodle Chain collator on Polkadot.

> Built on [Substrate](https://substrate.dev).


# Development

## Building
```
cargo build
```

## Testing
```
cargo test --all
```

## Installing
```
cargo install
```

## With docker

1. Build the image: `docker build -t nodle/chain -f .maintain/docker/Dockerfile .`.
2. Run it: `docker run -v /path/to/local/repertory:/data -p 9944:9944 -it nodle/chain`.


# Testing

## Running a local relay chain

1. Compile a relay chain node by following [these instructions](https://substrate.dev/cumulus-workshop/#/1-prep/1-compiling).
2. Fetch the appropriate chain spec by following [these instructions](https://substrate.dev/cumulus-workshop/#/1-prep/2-chain-spec).
3. Finally start your relay chain nodes by following [these instructions](https://substrate.dev/cumulus-workshop/#/2-relay-chain/2-launch).

## Start your collator

Let's first list our assumptions:
- You should have compiled the collator via `cargo build` or `cargo build --release`.
- You should have the compiled binary in your path with the name `nodle-chain-collator`.
- You should have a running relay chain.
- You should have kept your chain specification file used to start the relay chain, we assume it is named `relay_spec.json`.

Now let's get it done:
1. Start the collator: `nodle-chain-collator --tmp --ws-port 9997 --port 30336 --parachain-id 9000 --validator -- --chain relay_spec.json`.
2. Export the "genesis wasm" code via `nodle-chain-collator export-genesis-wasm > nodle-para.wasm`. This should create a file named `nodle-para.wasm`.
3. When the node start it will print a line of the type `Parachain genesis state: 0x0000000000000000000000000000000000000000000000000000000000000000000ac6efcd3b2a494d9b1a2ecc9b80aea20c1559215a7a1fbd04c52c71a628caa303170a2e7597b7b7e3d84c05391d139a62b157e78786d8c082f29dcf4c11131400`. You need to copy the part starting with `0x`, we call this the "genesis state".
4. Connect to the relay chain through your preferred means and submit the following extrinsic: `sudo(registrar.registerPara(9000, Always, CONTENT OF nodle-para.wasm, THE GENESIS STATE YOU COPIED))`.
5. Your collator should now start producing blocks and one of the relay chain's validators will validate its blocks.