{ pkgs, osConfig, config, ... }:

{
  programs.kitty = {
    enable = true;

    settings = {
      font_family = "UDEV Gothic NF";
      font_size = if osConfig.networking.hostName == "lyra" then 18 else 13;
      enable_audio_bell = false;
      confirm_os_window_close = 0;

      # Nightfox colors for Kitty
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
}
