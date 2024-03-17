{ pkgs }:

let
  themeUrl = "https://raw.githubusercontent.com/awtGerry/home-cfg/master/package/sddm/theme.conf";

  image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/l8/wallhaven-l8vp7y.jpg";
    hash = "sha256-MxmB+im6XVMUo8f0JJmzDNmPjnsB7RR2JpNKHYCKEDs=";
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
