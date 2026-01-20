{ config, ... }:

{
  config = {
    activeProfiles = [
      "development"
      "browsing"
    ];

    theme = {
      variant = "dark";
      baseScheme = "nightfox";
    };

    apps = {
      browser = "win";
      terminal = "win";
      editor = "helix";
      launcher = "wsl";
      music = "win"; # Dejar la musica en windows
    };

    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
