_:
{ config, lib, ... }:
let
  allowed = config.nixpkgs.allowedUnfree;
in
{
  options.nixpkgs.allowedUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''Permite paquetes que no libres (por nombre)'';
  };

  config.nixpkgs.config.allowUnfreePredicate =
    if (allowed == [ ]) then (_: false) else (pkg: builtins.elem (lib.getName pkg) allowed);
}
