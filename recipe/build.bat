@echo on
@setlocal EnableDelayedExpansion

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat
set OPENSSL_DIR=%LIBRARY_PREFIX%
set OPENSSL_NO_VENDOR=1

:: check licenses
cargo-bundle-licenses ^
    --format yaml ^
    --output THIRDPARTY.yml || goto :error

:: build statically linked binary with Rust
cargo install --no-track --locked --root %LIBRARY_PREFIX% --path . || goto :error

make -C contrib prefix=%LIBRARY_PREFIX% all || goto :error

goto :eof

:error
echo Failed with error #%errorlevel%.
exit 1
