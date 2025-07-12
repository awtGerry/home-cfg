{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.awt.homeConfigurations;
  enabledConfigs = lib.filterAttrs (_: config: config.enable) cfg;
  configs = builtins.mapAttrs (_: config: config.finalHome) enabledConfigs;
  packages = builtins.attrValues (builtins.mapAttrs (_: config: config.packageModule) enabledConfigs);
in
{
  options = {
    awt.homeConfigurations = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            options = {
              enable = lib.mkEnableOption "Activar esta configuracion." // {
                default = true;
              };

              nixpkgs = lib.mkOption {
                type = lib.types.unspecified;
                default = inputs.nixpkgs;
              };

              system = lib.mkOption {
                type = lib.types.enum [
                  "x86_64-linux"
                  "aarch64-linux"
                  "x86_64-darwin"
                  "aarch64-darwin"
                ];
              };

              username = lib.mkOption {
                type = lib.types.str;
                default = builtins.elemAt (lib.strings.split "@" name) 0;
              };

              hostname = lib.mkOption {
                type = lib.types.str;
                default = builtins.elemAt (lib.strings.split "@" name) 2;
              };

              entryPoint = lib.mkOption {
                type = lib.types.unspecified;
                readOnly = true;
              };

              base = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              homeDirectory = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              modules = lib.mkOption {
                type = lib.types.listOf lib.types.unspecified;
                default = [ ];
              };

              finalModules = lib.mkOption {
                type = lib.types.listOf lib.types.unspecified;
                readOnly = true;
              };

              packageName = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              finalPackage = lib.mkOption {
                type = lib.types.package;
                readOnly = true;
              };

              finalHome = lib.mkOption {
                type = lib.types.unspecified;
                readOnly = true;
              };

              packageModule = lib.mkOption {
                type = lib.types.unspecified;
                readOnly = true;
              };
            };

            config = lib.mkIf config.enable {
              # Ejemplo: gerry_artemis.nix
              entryPoint = import "${self}/home/configurations/${config.username}_${config.hostname}.nix";
              # Para macos
              base = if lib.strings.hasSuffix "-darwin" config.system then "Users" else "home";
              homeDirectory = "/${config.base}/${config.username}";

              finalModules =
                [
                  config.entryPoint
                  {
                    home = {
                      inherit (config) username homeDirectory;
                    };
                    _module.args = {
                      inherit inputs;
                    };
                  }
                  { systemd.user.startServices = "sd-switch"; }
                ]
                ++ config.modules
                ++ builtins.attrValues self.homeModules;

              packageName = "home/config/${name}";
              finalPackage = config.finalHome.activationPackage;

              packageModule = {
                ${config.system}.${config.packageName} = config.finalPackage;
              };

              finalHome = inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = config.nixpkgs.legacyPackages.${config.system};
                modules = config.finalModules;
              };
            };
          }
        )
      );
    };
  };

  config.flake.homeConfigurations = configs;
  config.flake.packages = lib.mkMerge packages;
}
