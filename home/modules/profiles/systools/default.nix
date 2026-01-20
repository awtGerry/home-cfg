_:
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.systools;
  isDark = config.theme.variant == "dark";
in
{
  options.profiles.systools = {
    enable = lib.mkEnableOption "Este perfil contiene programas que siempre quiero en mis sistemas completos (no vm o wsl)";
  };

  config = lib.mkIf cfg.enable {
    # Configuracion de GTK
    gtk = {
      enable = true;

      theme.package = pkgs.arc-theme;
      theme.name = if isDark then "Arc-Dark" else "Arc";

      cursorTheme.name = if isDark then "Posy_Cursor_Black" else "Posy_Cursor";
      cursorTheme.package = pkgs.posy-cursors;
      cursorTheme.size = 16;

      iconTheme.package = pkgs.kora-icon-theme;
      iconTheme.name = "kora";

      font = {
        name = "SF Pro Display 11";
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro;
      };

      # Probando otras fuentes...
      # font = {
      #   name = "Libertinus Sans 11";
      #   inputs.self.packages.${pkgs.system}.sf-pro;
      # };

      gtk3 = {
        bookmarks = [
          "file://${config.home.homeDirectory}/Documents"
          "file://${config.home.homeDirectory}/Downloads"
          "file://${config.home.homeDirectory}/Music"
          "file://${config.home.homeDirectory}/Pictures"
          "file://${config.home.homeDirectory}/Videos"
          "file://${config.home.homeDirectory}/Dev"
        ];
        extraConfig = {
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
          gtk-application-prefer-dark-theme = if isDark then 1 else 0;
        };
      };

      gtk4.extraConfig.gtk-application-prefer-dark-theme = if isDark then 1 else 0;
    };

    home.pointerCursor = {
      package = pkgs.posy-cursors;
      name = if isDark then "Posy_Cursor_Black" else "Posy_Cursor";
      size = 16;
      gtk.enable = true;
      x11.enable = true;
    };

    xsession = {
      enable = true;
      numlock.enable = true;
      # NOTA: Activar esta opcion si se desea usar teclado español por defecto!
      # profileExtra = ''
      #   setxkbmap es
      # '';
    };

    # Configuracion basica de audio
    services.mpd = {
      enable = true;
      musicDirectory = "/media/Drive/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
      network.listenAddress = "any"; # if you want to allow non-localhost connections
    };

    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "inode/directory" = [ "thunar.desktop" ];
      };
      defaultApplications = {
        "inode/directory" = [ "thunar.desktop" ];
      };
    };

    home.packages =
      with pkgs;
      [
        # Utilidades del sistema
        maim
        foliate # epub-reader
        gimp
        xfce.thunar
        dunst
        xdotool
        sxiv
        yt-dlp
        libnotify
        pulsemixer
        duf
        neofetch
        xdotool
        easyeffects

        # Documentos
        appflowy
        libreoffice
        texlab
        # texlive
        slides

        # Network
        networkmanager
      ]
      ++ lib.optional (config.apps.music == "spotify") spotify;

    nixpkgs.allowedUnfree = [
      "posy-cursors"
    ]
    ++ lib.optional (config.apps.music == "spotify") "spotify";
  };
}
