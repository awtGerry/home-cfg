{ pkgs }:

let
  # img = "https://w.wallhaven.cc/full/85/wallhaven-858lz1.png";
  img = "https://raw.githubusercontent.com/awtGerry/home-cfg/master/bg.png";
  # img = "https://github.com/awtGerry/home-cfg/blob/master/bg.png";
  # img = "https://github.com/awtGerry/home-cfg/bg.png";

  image = pkgs.fetchurl {
    url = img;
    # sha256 = "1n6xshmmhz5121lslgm8s3npb4qwlhbz5s8003c4x3vw4nlpj6jm";
    sha256 = "sha256-Jt5wTWLMXZ+sHgO1MuMlPDvTeQqM2Bl2O7R0cCaMiww=";
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
