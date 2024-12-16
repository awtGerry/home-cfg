_:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.profiles.development;
in
{
  options.profiles.development = {
    enable = lib.mkEnableOption "Habilita configuraciones y programas para desarrolladores";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = "Victor Rodriguez";
      userEmail = "awtGerry@gmail.com";

      extraConfig = {
        init.defaultBranch = "master";
        pull.rebase = "merges";
        rebase.autostash = true;
        diff.algorithm = "histogram";
      };

      ignores = [
        ".test"
        ".env"
        ".envrc"
        ".direnv"
        "result"
      ];
    };
    home.packages = [ ];

    # Configuraciones
    # imports = [ ];
  };
}
