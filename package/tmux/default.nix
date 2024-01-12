{ lib, pkgs, ... }:

let
  tmux = pkgs.tmux;
in
{
  programs.tmux = {
    enable = true;
    package = tmux;
    # shell = "\${pkgs.zsh}/bin/zsh";
    newSession = true;
    disableConfirmationPrompt = true;
    clock24 = true;
    extraConfig = ''
      set -g default-terminal "screen-256color"
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

      bind-key -r f run-shell "tmux neww ~/Github/home-cfg/package/tmux/tmux-fzf.sh"
    '';
  };

  # Automatically start tmux on SSH sessions
  # programs.bash.profileExtra = lib.mkAfter ''
  #   if [ -z "$TMUX" ] && [ -n "$SSH_TTY" ]; then
  #     exec ${tmux}/bin/tmux
  #   fi
  # '';
}
