{ config, pkgs, lib, ...}:

let
  picom = pkgs.picom;
in
{
  enable = true;
  package = picom;
}
