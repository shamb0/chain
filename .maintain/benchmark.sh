#! /bin/sh

./target/release/nodle-chain benchmark --chain dev --steps 1 --repeat 1 --pallet $1 --extrinsic "*" --raw --execution=wasm --wasm-execution=compiled --output --weight-trait
./target/release/nodle-chain benchmark --chain dev --steps 1 --repeat 1 --pallet $1 --extrinsic "*" --raw --execution=wasm --wasm-execution=compiled --output