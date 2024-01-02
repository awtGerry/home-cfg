{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Enable home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        awt = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./system/configuration.nix
          ];
        };
        maria = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./host/maria.nix
          ];
        };
      };
    };
}
