{ lib, pkgs, config, ... }:

let
  wezterm = pkgs.wezterm;
in
{
  enable = true;
  package = wezterm;
  extraConfig = {
    font = wezterm.font("Fira Code");
    font_size = 18.0;
  };
}
