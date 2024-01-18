{ pkgs }:

let
  imgUrl = "https://raw.githubusercontent.com/awtGerry/home-cfg/master/bg.jpg";
  themeUrl = "https://raw.githubusercontent.com/awtGerry/home-cfg/master/package/sddm/theme.conf";

  image = pkgs.fetchurl {
    url = imgUrl;
    sha256 = "sha256-2FMvWIjeTTtSmVzjQdBh6ImLVrJ6raSQaV+VvGiUNuQ=";
  };

  theme = pkgs.fetchurl {
    url = themeUrl;
    sha256 = "sha256-yRyVrpAqPhUGIeajiUPeGD2DJO/4ZWJ2lKqQkYB9aiI=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Kangie";
    repo = "sddm-sugar-candy";
    rev = "a1fae5159c8f7e44f0d8de124b14bae583edb5b8";
    sha256 = "18wsl2p9zdq2jdmvxl4r56lir530n73z9skgd7dssgq18lipnrx7";
  };

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out
    rm theme.conf
    cp -r ${image} Backgrounds/bg.jpg
    cp -r ${theme} theme.conf
  '';
}
