{ lib, ... }:

{
  imports = [
    ../system/desktop.nix
    ../system/gaming.nix
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "discord"
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
      "unrar"
    ];

    permittedInsecurePackages = [
      "electron-24.8.6"
      "openssl-1.1.1v"
    ];
  };

  home.stateVersion = "22.11";
}
