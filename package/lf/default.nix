{ pkgs, lib, ... }:

{
  programs.lf = {
    enable = true;
    package = pkgs.lf;
  };
}
