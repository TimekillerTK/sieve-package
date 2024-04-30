{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./sieve.nix {}