{ pkgs, config, ... }:

let
  # Traducir espanol a ingles
  ts-es = "${config.apps.terminal} -e ${pkgs.translate-shell}/bin/trans -b -sl en -tl es --shell";
  # Traducir ingles a espanol
  ts-en = "${config.apps.terminal} -e ${pkgs.translate-shell}/bin/trans -b -sl es -tl en --shell";
in
{
  home.packages = [
    ts-es
    ts-en
    pkgs.translate-shell
  ];
}
