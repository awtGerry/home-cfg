# Instala la fuente de apple

{
  stdenv,
  fetchFromGithub,
  unzip,
}:

stdenv.mkDerivation (self: {
  pname = "SF-Pro";
  version = "3";

  src = fetchFromGithub {
    owner = "sahibjotsaggu";
    name = "San-Francisco-Pro-Fonts";
    rev = "master";
    sha256 = "";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/fonts/truetype
    cp *.otf $out/share/fonts/opentype
    cp *.otf $out/share/fonts/truetype
  '';
})
