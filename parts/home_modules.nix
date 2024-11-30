{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.awt.homeModules;
  inherit (import ./helpers.nix lib inputs) submodule;
  modules = builtins.mapAttrs (_: config: config.wrappedModule) cfg;
in
{
  options = {
    awt.homeModules = lib.mkOption { type = lib.types.attrsOf submodule; };
  };

  config.flake.homeModules = modules;
}
