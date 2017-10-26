{ nixpkgs ? import <nixpkgs> {} }:

let

  inherit (nixpkgs) pkgs;
  ghc = pkgs.haskellPackages.ghc;
  hsPkgs = pkgs.haskellPackages;
  stdenv = pkgs.stdenv;

  julius = hsPkgs.callPackage ../julius/default.nix {};
  #hsmfcc = hsPkgs.callPackage ../hsmfcc/default.nix {};

  pretty-simple = hsPkgs.callPackage ~/repos/pretty-simple        {};
  drv = hsPkgs.callPackage ./default.nix {inherit pretty-simple julius;};

in if pkgs.lib.inNixShell then drv.env else drv
