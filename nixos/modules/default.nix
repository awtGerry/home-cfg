# inputs: {
#   flake = import ./flake.nix inputs;
#   nix = import ./nix.nix inputs;
# }

{
  awt.nixosModules = {
    flake = ./flake.nix;
    nix = ./nix.nix;
  };
}
