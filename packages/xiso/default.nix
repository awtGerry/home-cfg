{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "extract-xiso";
  version = "3";

  src = fetchFromGitHub {
    owner = "XboxDev";
    repo = "extract-xiso";
    rev = "master";
    sha256 = "";
  };
  makeFlags = [ "PREFIX=$(out)" ];

  installPhase = ''
    mkdir -p $out/bin
    cp extract-xiso $out/bin/
  '';

  meta = with lib; {
    description = "Tool to extract Xbox ISO (XISO) files";
    homepage = "https://github.com/XboxDev/extract-xiso";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
