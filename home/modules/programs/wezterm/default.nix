_:
{ config, lib, ... }:
let
  cfg = config.programs.wezterm;
in
{
  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      extraConfig = ''
        local config =  {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        -- For some reason wezterm won't work on wayland if not added this line.
        config.enable_wayland = false;

        config.font_size = 14

        config.enable_tab_bar = false;
        config.window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0
        }

        config.default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux-fzf || tmux new -s dev" }

        config.window_close_confirmation = "NeverPrompt"
        config.audible_bell = "Disabled"

        return config
      '';
    };
  };
}
