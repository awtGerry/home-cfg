{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim;
  };
}
