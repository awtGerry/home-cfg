{ lib, .. }:

{
  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "discord",
      "steam",
      "steam-original",
      "steam-run",
    ];

    permittedInsecurePackages = [
      "electron"
    ];
  };
}
