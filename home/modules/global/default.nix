_:
{ lib, config, ... }:

{
  options.apps = {
    browser = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "Navegador principal";
    };
    terminal = lib.mkOption {
      type = lib.types.str;
      default = "ghostty";
      description = "Terminal del sistema";
    };
    editor = lib.mkOption {
      type = lib.types.str;
      default = "helix";
      description = "Editor principal";
    };
    launcher = lib.mkOption {
      type = lib.types.str;
      default = "rofi";
      description = "Launcher";
    };
    music = lib.mkOption {
      type = lib.types.str;
      default = "rmpc";
      description = "Music Player";
    };
  };

  options.dirs = {
    # Directorio de este repositorio
    # (se utiliza en algunas configuraciones hasta que consiga una mejor manera)
    repoDir = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/public/home-cfg";
    };
    publicRepos = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/public/";
    };
    privateRepos = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/Dev/private/";
    };
  };
}
