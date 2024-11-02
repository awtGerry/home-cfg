_:
{ config, lib, ... }:
let
  profileEnabler =
    let
      reducer = l: r: { "${r}".enable = true; } // l;
    in
    builtins.foldl' reducer { } config.activeProfiles;
in
{
  _file = ./default.nix;
}
