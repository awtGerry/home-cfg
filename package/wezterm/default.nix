{ lib, pkgs, config, osConfig, ... }:

let
  font = "JetBrains Mono";
  fsize = if osConfig.networking.hostName == "lyra" then 18 else 13;
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
    local config = {}
    if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- For some reason we need to set this to false in wayland
      config.enable_wayland = false;

      config.color_scheme = 'nightfox'

      config.font = wezterm.font_with_fallback { "${font}" }
      config.font_size = 18

      config.enable_scroll_bar = false
      -- config.use_fancy_tab_bar = false
      config.enable_tab_bar = false
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }

      config.automatically_reload_config = true
      config.freetype_load_target = "HorizontalLcd"

      config.window_background_opacity = 1.0
      config.window_close_confirmation = "NeverPrompt"

      config.audible_bell = "Disabled"

      return config
    '';

    enableZshIntegration = true;
  };
}
