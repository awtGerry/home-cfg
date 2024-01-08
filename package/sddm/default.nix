{ pkgs }:

let
  # img = "https://w.wallhaven.cc/full/85/wallhaven-858lz1.png";
  img = "https://github.com/awtGerry/home-cfg/bg.png";

  image = pkgs.fetchurl {
    url = img;
    sha256 = "1yx7vnd35j8g9g7m01y3kr30ncrnkaar68wpsdw7qnyxisrcbgi9";
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
