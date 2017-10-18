{ mkDerivation, base, stdenv, julius, vector, hsmfcc, bytestring }:
mkDerivation {
  pname = "hsjulius";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base vector hsmfcc bytestring];
  librarySystemDepends = [ julius ];
  license = stdenv.lib.licenses.bsd3;
}
