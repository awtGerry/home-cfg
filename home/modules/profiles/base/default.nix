# Todos los perfiles comparten esta configuracion

# Home manager configuracion base:
{ self, nix, ... }:

{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.base;
  dark = if config.theme.variant == "dark" then true else false;
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
      # theme.name = if config.theme.variant == "dark" then "Arc-Dark" else "Arc";
      theme.name = if dark then "Arc-Dark" else "Arc"; # TODO: Ver si funciona para cambiar el resto.

      iconTheme.package = pkgs.kora-icon-theme;
      iconTheme.name = "kora";

      font = {
        name = "SF Pro Display";
        package = self."sf/pro";
      };

      gtk3 = {
        # TODO
        # bookmarks = [
        #   "file://${config.home.homeDirectory}/Documents"
        #   "file://${config.home.homeDirectory}/Downloads"
        #   "file://${config.home.homeDirectory}/Music"
        #   "file://${config.home.homeDirectory}/Pictures"
        #   "file://${config.home.homeDirectory}/Videos"
        #   "file://${config.home.homeDirectory}/Dev"
        # ];
        extraConfig = {
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
          gtk-application-prefer-dark-theme = if config.theme.variant == "dark" then 1 else 0;
        };
      };

      gtk4.extraConfig.gtk-application-prefer-dark-theme =
        if config.theme.variant == "dark" then 1 else 0;
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
      home-manager.enable = true;
      bat.enable = true;
      fzf.enable = true;
      btop.enable = true;

      ssh.enable = true;

      firefox.enable = true;
      helix.enable = true;

      tmux = {
        enable = true;
        newSession = true;
        disableConfirmationPrompt = true;
        clock24 = true;
        terminal = "screen-256color";
        extraConfig = ''
          unbind C-b
          set -g prefix C-Space

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
    };
  };
}
