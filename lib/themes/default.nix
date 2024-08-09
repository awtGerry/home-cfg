{ config, pkgs, lib, ... }:

{
  options = with lib; with types; {
    darkmode = mkOption { type = bool; };
  };
  config = {
    darkmode = true;
  };
}
