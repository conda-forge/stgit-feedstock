#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --no-track --locked --root ${PREFIX} --path .

if [[ ${build_platform} == ${target_platform} ]]; then
    mkdir -p ${PREFIX}/etc/bash_completion.d 
    mkdir -p ${PREFIX}/share/fish/vendor_completions.d 
    mkdir -p ${PREFIX}/share/zsh/site-functions
    stg completion bash > ${PREFIX}/etc/bash_completion.d/stg
    stg completion fish > ${PREFIX}/share/fish/vendor_completions.d/stg.fish
    stg completion zsh > ${PREFIX}/share/zsh/site-functions/_stg
fi

make -C contrib prefix=${PREFIX} all
