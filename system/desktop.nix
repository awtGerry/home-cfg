{ pkgs, config, lib, inputs, ... }:

# Main pc configuration

{
  imports = [
    ./base.nix
    ./gaming.nix

    ../package/hyprland
    ../package/waybar
  ];

  home.username = "gerry";

  home = {
    packages = with pkgs; [
      # Wayland
      xorg.xprop
      polkit
      xdg-desktop-portal
      dconf
      xwayland
      xwaylandvideobridge

      discord
      gimp
      figma-linux
      inter

      # TODO: change this to his own file.
      # Documents
      libreoffice
      ffmpeg
      pandoc
      presenterm
      chafa # Image to ASCII
    ];

    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };


    sessionVariables = {
      # Use Wayland for Chrome & Electron apps
      NIXOS_OZONE_WL = 1;

      # Improve appearance of Java applications
      # https://wiki.archlinux.org/index.php/Java#Tips_and_tricks
      JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    };
  };

  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
    <fontconfig>
      <alias binding="same">
      <family>sans-serif</family>
      <prefer><family>Inter</family></prefer>
      </alias>
    </fontconfig>
  '';

  xdg.configFile."wireplumber/main.lua.d/51-restrict-control.lua".text = ''
    table.insert(default_access.rules, {
      matches = {
        {
          { "application.process.binary", "matches", "*chromium*" },
        },
        {
          { "application.process.binary", "matches", "*Discord*" },
        },
        {
          { "application.process.binary", "matches", "*electron*" },
        },
        {
          { "application.process.binary", "matches", "*firefox*" },
        },
      },
      default_permissions = "rx",
    })
  '';

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
