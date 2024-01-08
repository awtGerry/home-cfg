{ pkgs, lib, inputs, ... }:

{
  imports = [
    # Hardware
    ../maria/hardware/system.nix

    # NixOS modules
    inputs.home-manager.nixosModules.default

    # System defaults
    # ../../system/desktop.nix
    # ../system/gaming.nix
  ];

  system.stateVersion = "23.11";

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gerry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "gerry" = import ../../system/desktop.nix;
    };
  };

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
