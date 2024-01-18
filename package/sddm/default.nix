{ pkgs }:

let
  imgUrl = "https://raw.githubusercontent.com/awtGerry/home-cfg/master/bg.jpg";

  image = pkgs.fetchurl {
    url = imgUrl;
    sha256 = "sha256-2FMvWIjeTTtSmVzjQdBh6ImLVrJ6raSQaV+VvGiUNuQ=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  # src = pkgs.fetchFromGitHub {
  #   owner = "MarianArlt";
  #   repo = "sddm-sugar-dark";
  #   rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
  #   sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  # };

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
    rm Backgrounds/Mountain.jpg
    cp -r ${image} Backgrounds/Mountain.jpg
  '';
}
