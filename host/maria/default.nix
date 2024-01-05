{ lib, ... }:

{
  imports = [

    # Hardware
    ../maria/hardware/system.nix

    # System defaults
    ../system/desktop.nix
    # ../system/gaming.nix
  ];

  system.stateVersion = "23.11";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
}
