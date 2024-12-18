# Instala la fuente de apple
{
  stdenv,
  fetchFromGitHub,
  unzip,
}:

stdenv.mkDerivation {
  pname = "SF-Pro";
  version = "3";

  src = fetchFromGitHub {
    owner = "sahibjotsaggu";
    repo = "San-Francisco-Pro-Fonts";
    rev = "master";
    sha256 = "sha256-mAXExj8n8gFHq19HfGy4UOJYKVGPYgarGd/04kUIqX4=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    mkdir -p $out/share/fonts/truetype
    cp *.otf $out/share/fonts/opentype
    cp *.ttf $out/share/fonts/truetype  # Changed otf to ttf for truetype
  '';
}
