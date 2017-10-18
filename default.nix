{ mkDerivation, base, stdenv, julius, vector }:
mkDerivation {
  pname = "hsjulius";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base vector ];
  librarySystemDepends = [ julius ];
  license = stdenv.lib.licenses.bsd3;
}
