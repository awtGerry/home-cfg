{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.awt.nixosModules;
  inherit (import ./helper.nix lib inputs) submodule;
  modules = builtins.mapAttrs (_: config: config.wrappedModule) cfg;
in
{
  options = {
    awt.nixosModules = lib.mkOption { type = lib.types.attrsOf submodule; };
  };

  config.flake.nixosModules = modules;
}
