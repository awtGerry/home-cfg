{ pkgs, ...}:

let
  zsh = pkgs.zsh;
in
{
  programs.zsh.enable = true;
}
