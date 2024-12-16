{
  description = "Configuracion de NixOS";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      # _module.args.npins = import ./npins; # NOTA: Aun no se si usar npins o hacerlo manual.

      imports = [
        ./parts/system.nix
        ./parts/home.nix
        ./parts/home_modules.nix

        ./nixos/configurations
        ./home/configurations

        ./home/modules
        ./nixos/modules

        ./packages
      ];

      # flake = {
      #   nixosModules = import ./nixos/modules inputs;
      #   homeModules = import ./home/modules inputs;
      # };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";

    nix.url = "github:nixos/nix";
    nix.inputs.flake-parts.follows = "flake-parts";
    nix.inputs.nixpkgs.follows = "nixpkgs";

    # Arregla command-not-found para sqlite
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    # Simplificar nix flakes
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Mantiene el sistema limpio
    # impermanence = "github:nix-community/impermanence?ref=opensource";

    # eww.url = "github:elkowar/eww";
    # eww.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    # Modifica la apariencia de spotify
    spictify.url = "github:MichaelPachec0/spicetify-nix";
    spictify.inputs.nixpkgs.follows = "nixpkgs";
  };
}
