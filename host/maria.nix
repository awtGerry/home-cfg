{ lib, ... }:

{
  imports = [
    ../system/desktop.nix
    # Main desktop config
    ../system/gaming.nix
  ];


  # Allowing some unfree packages for maria computer
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "discord"
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
      "unrar"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1v"
    ];
  };

  # System state version
  system.stateVersion = "23.11";
}
