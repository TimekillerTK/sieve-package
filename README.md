# sieve editor Nix Package

Nix package for https://github.com/thsmi/sieve

Sources used during packaging:
* https://stackoverflow.com/questions/78004799/package-electron-application-in-nix
* https://github.com/tobiasBora/basic-nix-packaging

## How to use

> NOTE: Only tested on macOS!

Just download this repo and execute `nix-build`, it will output the package in `./result` and you can run the editor with `./result/bin/sieve-editor`
