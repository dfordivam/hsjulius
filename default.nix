{ mkDerivation, base, stdenv, vector, bytestring, pretty-simple, julius }:
mkDerivation {
  pname = "hsjulius";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base vector bytestring pretty-simple];
  librarySystemDepends = [ julius ];
  license = stdenv.lib.licenses.bsd3;
}
