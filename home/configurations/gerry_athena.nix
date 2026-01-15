{ config, pkgs, ... }:

{
  config = {
    activeProfiles = [
      "development"
      "browsing"
    ];

    theme = {
      variant = "light";
      baseScheme = "e-ink";
    };

    apps = {
      browser = "firefox";
      terminal = "st";
      editor = "helix";
    };

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];

    home.packages = with pkgs; [
      auto-cpufreq
      cpulimit
      xwallpaper
      neovim
    ];
  };
}

