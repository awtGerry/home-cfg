{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Enable home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    # My personal packages
    # tudus.url = "github:awtgerry/tudus";
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    home-manager,
    ...
    } @ inputs:
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
        # Home-manager configuration
        lyra = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/lyra/default.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        # Laptop configuration
        pady = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/pady/default.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
