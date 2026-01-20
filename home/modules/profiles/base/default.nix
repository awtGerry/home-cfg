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
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "Perfil base, siempre activo";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      bat.enable = true;
      btop.enable = true;
      fzf.enable = true;
      helix.enable = config.apps.editor == "helix";
      # nixvim.enable = config.apps.editor == "nvim";
      nixvim.enable = true;
      kitty.enable = config.apps.terminal == "kitty";
      ghostty.enable = config.apps.terminal == "ghostty";
      awtst.enable = config.apps.terminal == "st";
      home-manager.enable = true;
      lsd.enable = true;
      ssh = {
        enable = true;
        enableDefaultConfig = false;
      };
      rmpc.enable = config.apps.music == "rmpc";

      anyrun.enable = config.apps.launcher == "anyrun";
      rofi.enable = config.apps.launcher == "rofi";

      tmux = {
        enable = true;
        disableConfirmationPrompt = true;
        terminal = "xterm-256color"; # Arregla problemas con gruvbox
        clock24 = true;

        extraConfig = ''
          unbind C-b
          set -g prefix C-Space
          set -sg escape-time 0 

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
      "unrar"
    ];

    # Otros programas
    home.packages = with pkgs; [
      # Conversion de archivos
      unrar
      unzip
      p7zip
      zip

      xclip
      curl
      nmap
      whois
      wget
    ];
  };
}
