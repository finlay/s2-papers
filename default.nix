{ mkDerivation, aeson, base, bytestring, cassava, stdenv, text }:
mkDerivation {
  pname = "s2-papers";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ aeson base bytestring cassava text ];
  license = stdenv.lib.licenses.bsd3;
}
