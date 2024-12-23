# Todos los perfiles comparten esta configuracion

# Home manager configuracion base:
_:
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.profiles.base;
  isDark = config.theme.variant == "dark";
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "Perfil base, siempre activo";
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
        name = "SF Pro Display";
        package = inputs.self.packages.${pkgs.system}.sf-pro;
      };

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

    programs = {
      bat.enable = true;
      btop.enable = true;
      firefox.enable = true; # Todos tienen firefox, solo los 'browsing' tienen firefox personalizado
      fzf.enable = true;
      helix.enable = true;
      home-manager.enable = true;
      lsd.enable = true;
      ssh.enable = true;
      rofi.enable = true;

      kitty = {
        enable = true;
        settings = {
          font_family = "Fira Code";
          font_size = 14;
          enable_audio_bell = false;
          confirm_os_window_close = 0;

          # Nightfox colors
          ## name: nightfox
          ## upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/nightfox/kitty.conf
          background = "#152528";
          foreground = "#cdcecf";
          selection_background = "#2b3b51";
          selection_foreground = "#cdcecf";
          cursor_text_color = "#192330";
          url_color = "#81b29a";

          # Cursor
          # uncomment for reverse background
          # cursor none
          cursor = "#cdcecf";

          # Border
          active_border_color = "#719cd6";
          inactive_border_color = "#39506d";
          bell_border_color = "#f4a261";

          # Tabs
          active_tab_background = "#719cd6";
          active_tab_foreground = "#131a24";
          inactive_tab_background = "#2b3b51";
          inactive_tab_foreground = "#738091";

          # normal
          color0 = "#393b44";
          color1 = "#c94f6d";
          color2 = "#81b29a";
          color3 = "#dbc074";
          color4 = "#719cd6";
          color5 = "#9d79d6";
          color6 = "#63cdcf";
          color7 = "#dfdfe0";

          # bright
          color8 = "#575860";
          color9 = "#d16983";
          color10 = "#8ebaa4";
          color11 = "#e0c989";
          color12 = "#86abdc";
          color13 = "#baa1e2";
          color14 = "#7ad5d6";
          color15 = "#e4e4e5";

          # extended colors
          color16 = "#f4a261";
          color17 = "#d67ad2";
        };
      };

      tmux = {
        enable = true;
        disableConfirmationPrompt = true;
        terminal = "screen-256color";
        clock24 = true;

        extraConfig = ''
          unbind C-b
          set -g prefix C-Space

          # basics
          set -g status-style 'bg=#101010 fg=#EEEEEE'
          set -g base-index 1
          set-option -g history-limit 64096
          set-option -g pane-active-border-style fg='#08D9D6'
          set-window-option -g window-status-current-style fg='#08D9D6'

          # vi settings
          set-window-option -g mode-keys vi
          bind -T copy-mode-vi v send-keys -X begin-selection
          bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
          bind -r ^ last-window
          bind -r k select-pane -U
          bind -r j select-pane -D
          bind -r h select-pane -L
          bind -r l select-pane -R

          # Moving window
          bind-key -n C-S-Left swap-window -t -1 \; previous-window
          bind-key -n C-S-Right swap-window -t +1 \; next-window
          # Resizing pane
          bind -r C-k resize-pane -U 5
          bind -r C-j resize-pane -D 5
          bind -r C-h resize-pane -L 5
          bind -r C-l resize-pane -R 5

          bind-key -r f run-shell "tmux neww tmux-fzf"
        '';
      };

      yazi.enable = true;
      zathura.enable = true;
      zsh.enable = true;
    };

    nixpkgs.allowedUnfree = [
      "posy-cursors"
      "unrar"
    ];

    # Otros programas
    home.packages = with pkgs; [
      # Conversion de archivos
      unrar
      unzip
      p7zip
      zip

      # Utilidades del sistema
      xfce.thunar
      xdotool
      sxiv
      yt-dlp
      libnotify
      pulsemixer
      duf
      neofetch
      xdotool
      # Network
      curl
      nmap
      whois
      wget
    ];
  };
}
