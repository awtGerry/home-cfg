{
  nixpkgs,
  rust-overlay,
  programsdb,
  ...
}:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  base = "/etc/nixpkgs/channels";
  nixpkgsPath = "${base}/nixpkgs";
in
{
  options.nix.flakes.enable = lib.mkEnableOption "nix flakes";

  config = lib.mkIf config.nix.flakes.enable {
    # programs.command-not-found.dbPath = programsdb.packages.${pkgs.stdenv.hostPlatform.system}.programs-sqlite; # TODO

    nixpkgs.overlays = [ rust-overlay.overlays.default ];
    environment.systemPackages = [
      pkgs.rust-bin.stable.latest.default
    ];

    nix = {
      # Usa el nix de nixpkgs (precompilado). El input github:nixos/nix
      # compilaba master desde fuente y truena con boost de unstable.
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      registry.nixpkgs.flake = nixpkgs;

      nixPath = [
        "nixpkgs=${nixpkgsPath}"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };

    systemd.tmpfiles.rules = [ "L+ ${nixpkgsPath}     - - - - ${nixpkgs}" ];
  };
}
