# Todos comparten esta configuracion.

{ self, nix, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.base;
in
{
  _file = ./default.nix;
}
