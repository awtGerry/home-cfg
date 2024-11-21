{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.awt.nixosConfigurations;
  configs = builtins.mapAttrs (_: config: config.finalSystem) cfg;
  packages = builtins.attrValues (builtins.mapAttrs (_: config: config.packageModule) cfg);
in
{
  options = {
    # Atributos para la configuracion de nixos
    awt.nixosConfigurations = lib.mkOptions {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, config, ... }:
          {
            # Submodulos
            options = {
              # Cual nixpkgs se usara
              nixpkgs = lib.mkOption {
                type = lib.types.unspecified;
                default = inputs.nixpkgs;
              };
              # Arquitectura del sistema
              system = lib.mkOption {
                type = lib.types.enum [
                  "x86_64-linux"
                  "aarch64-linux"
                ];
              };

              # Modulos adicionales
              modules = lib.mkOption {
                type = lib.types.listOf lib.types.unspecified;
                default = [ ];
              };

              # Archivos de solo lectura para valores derivados
              configFolder = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              entryPoint = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              bootloader = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              hardware = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              finalModules = lib.mkOption {
                type = lib.types.listOf lib.types.uspecified;
                readOnly = true;
              };

              packageName = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };

              finalPackage = lib.mkOption {
                type = lib.types.str;
                readOnly = true;
              };
            };

            config = {
              configFolder = "${self}/nixos/configurations";
              entryPoint = import "${config.configFolder}/${name}.nix" (inputs // { inherit self; });
              bootloader = "${config.configFolder}/bootloader/${name}.nix";
              hardware = "${config.configFolder}/hardware/${name}.nix";

              finalModules =
                [
                  { boot.tmp.cleanOnBoot = true; }
                  { networking.hostName = name; }
                  { nix.flakes.enable = true; }
                  { documentation.man.enable = true; }
                  { documentation.man.generateCaches = true; }
                  { nixpkgs.hostPlataform.system = config.system; }
                ]
                ++ config.modules
                ++ builtins.attrValues { inherit (config) entryPoint bootloader hardware; }
                ++ builtins.attrValues self.nixosModules
                ++ builtins.attrValues self.mixedModules;

              packageName = "nixos/config/${name}";
              finalPackage = config.finalSystem.config.system.build.toplevel;
              packageModule = {
                ${config.system}.${config.packageName} = config.finalPackage;
              };

              finalSystem = config.nixpkgs.lib.nixosSystem { modules = config.finalModules; };
            };
          }
        )
      );
    };
  };

  config.flake.nixosConfigurations = configs;
  config.flake.packages = lib.mkMerge packages;
}
