# Inspired by pkgs/applications/editors/uivonim/default.nix
# and pkgs/by-name/in/indiepass-desktop/package.nix
{ pkgs, lib, buildNpmPackage, fetchFromGitHub, electron, nodePackages, nodejs_18 }:

buildNpmPackage rec {
  pname = "sieve-editor";
  version = "0.6.2";

  src = pkgs.fetchFromGitHub {
    owner = "thsmi";
    repo = "sieve";
    rev = "5879679ed8d16a34af760ee56bfec16a1a322b4e";
    sha256 = "sha256-wl6dwKoGan+DrpXk2p1fD/QN/C2qT4h/g3N73gF8sOI=";
  };

  npmDepsHash = "sha256-a2I9csxFZJekG1uCOHqdRaLLi5v/BLTz4SU+uBd855A="; # you will get an error about mismatching hash the first time. Just copy the hash here

  # Useful for debugging, just run "nix-shell" and then "electron ."
  nativeBuildInputs = [
    electron
    nodePackages.gulp
    nodejs_18
  ];

  # Sieve does not currently support Node20, so using 18
  nodejs = nodejs_18;

  postBuild = ''
    mkdir $out
    gulp app:package
    cp -R ./build/electron/resources $out/lib/
  '';

  # Otherwise it will try to run a build phase (via npm build) that we don't have or need, with an error:
  # Missing script: "build"
  # This method is used in pkgs/by-name/in/indiepass-desktop/package.nix
  dontNpmBuild = true;

  # Needed, otherwise you will get an error:
  # RequestError: getaddrinfo EAI_AGAIN github.com
  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };
  
  # The node_modules/XXX is such that XXX is the "name" in package.json
  # The path might differ, for instance in electron-forge you need build/main/main.js
  postInstall = ''
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/lib/main_esm.js
  '';
}