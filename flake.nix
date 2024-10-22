{
  description = "NixOS configuration";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./parts/system.nix
        ./parts/home.nix

        ./nixos/configurations
        ./home/configurations

        ./hosts
        ./lib

        ./packages
      ];

      flake = {
        nixosModules = import ./nixos/modules inputs;
        homeModules = import ./home/modules inputs;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";

    # Simplify Nix Flakes with the module system
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Keep the system clean
    # impermanence = "github:nix-community/impermanence?ref=opensource";

    # eww.url = "github:elkowar/eww";
    # eww.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    spictify.url = "github:MichaelPachec0/spicetify-nix";
    spictify.inputs.nixpkgs.follows = "nixpkgs";
  };
}
