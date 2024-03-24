{ pkgs, config, lib, inputs, ... }:

# Main pc configuration

{
  imports = [
    ./base.nix
    ./gaming.nix

    ../package/hyprland
    ../package/waybar
    ../package/thunderbird
  ];
  # ++ (with inputs.nixos-hardware.nixosModules; [
  #   common-cpu-amd
  #   common-gpu-amd
  #   common-pc-ssd
  # ]);

  home.username = "gerry";

  home = {
    packages = with pkgs; [
      spotify

      # Wayland
      xorg.xprop
      dunst
      polkit
      dconf
      xwayland
      xwaylandvideobridge
      swww

      wl-clipboard
      wlr-randr
      slurp
      grim
      slurp

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
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
  xdg.portal.config.common.default = "*";

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName (lib.getName pkg)).name [
      "anytype"
      "anytype-heart"
      "clonehero"
      "clonehero-unwrapped"
      "data.zip"
      "discord"
      "minecraft-server"
      "sm64ex"
      "spotify"
      "steam"
      "steam-jupiter-original"
      "steam-original"
      "steam-run"
      "steamdeck-hw-theme"
      "snes9x"
      "vvvvvv"
      "unrar"
    ];

    permittedInsecurePackages = [
      "openssl-1.1.1v"
      "nix-2.16.2" # Required by nixd
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
