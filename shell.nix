{ nixpkgs ? import <nixpkgs> {} }:

let

  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskellPackages.ghc;
  hsPkgs = pkgs.haskellPackages;
  stdenv = pkgs.stdenv;

  julius = hsPkgs.callPackage ../julius/default.nix {};

  drv = hsPkgs.callPackage ./default.nix {inherit julius;};

in if pkgs.lib.inNixShell then drv.env else drv
