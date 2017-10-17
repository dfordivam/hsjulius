{ mkDerivation, base, stdenv, julius }:
mkDerivation {
  pname = "hsjulius";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base ];
  librarySystemDepends = [ julius ];
  license = stdenv.lib.licenses.bsd3;
}
