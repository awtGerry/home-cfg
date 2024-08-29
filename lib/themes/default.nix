{ config, pkgs, lib, ... }:

# Here we change the default configs

{
  options = with lib; with types; {
    darkmode = mkOption { type = bool; };
  };
  config = {
    darkmode = true;
  };
}
