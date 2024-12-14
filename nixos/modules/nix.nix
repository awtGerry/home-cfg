_:
{ config, lib, ... }:
let
  allowed = config.nix.allowedUnfree;
in
{
  options.nix = {
    allowedUnfree = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''Permite paquetes no libres por nombre'';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (allowed != [ ]) {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) allowed;
    })
    { nix.settings.auto-optimise-store = lib.mkDefault true; }
    {
      nix.settings.trusted-users = lib.mkDefault [
        "root"
        "@wheel"
      ];
      nix.settings.allow-import-from-derivation = lib.mkDefault false;
    }
  ];
}
