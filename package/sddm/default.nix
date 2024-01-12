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
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out
    rm Background.jpg
    cp -r ${image} Background.jpg
  '';
}
