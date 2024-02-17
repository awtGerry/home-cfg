{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Enable home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      lib = nixpkgs.lib // home-manager.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      nvim-cfg = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-cfg";
        src = ./package/furry-nvim;
      };
    in
    {
      nixosConfigurations = {
        awt = nixpkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./system/configuration.nix
          ];
        };

        # Home-manager configuration
        lyra = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/lyra/default.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
