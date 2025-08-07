{ pkgs, ... }:

let
  # Traducir espanol a ingles
  # ts-es = ;
  ts-es = pkgs.writeShellScriptBin "ts-es" ''
    ${pkgs.translate-shell}/bin/trans -b -sl en -tl es --shell
  '';
  # Traducir ingles a espanol
  ts-en = pkgs.writeShellScriptBin "ts-en" ''
    ${pkgs.translate-shell}/bin/trans -b -sl es -tl en --shell
  '';
in
{
  home.packages = [
    ts-es
    ts-en
  ];
}
