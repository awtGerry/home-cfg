{ lib, pkgs, config, ... }:

let
  wezterm = pkgs.wezterm;
in
{
  programs.wezterm = {
    enable = true;
    package = wezterm;
    extraConfig = ''
      local function font_with_fallback(name, params)
        local names = { name, "Apple Color Emoji", "azuki_font" }
        return wezterm.font_with_fallback(names, params)
      end

      local font_name = "FiraCodeNerdFont"

      return {
        front_end = "OpenGL",
        color_scheme = "rose-pine",
        font = font_with_fallback(font_name),
        font_rules = {
          {
            italic = true,
            font = font_with_fallback(font_name, { italic = false }),
          },
          {
            italic = false,
            font = font_with_fallback(font_name, { bold = false }),
          },
          {
            intensity = "Bold",
            font = font_with_fallback(font_name, { bold = true }),
          },
        },
        warn_about_missing_glyphs = false,
        font_size = 14.0,
        line_height = 1.0,
        dpi = 96.0,

        -- Night Color
        bold_brightens_ansi_colors = true,
        -- Padding
        window_padding = {
          left = 8,
          right = 8,
          top = 8,
          bottom = 8,
        },

        -- Tab bar
        enable_tab_bar = true,
        hide_tab_bar_if_only_one_tab = true,
        show_tab_index_in_tab_bar = false,
        tab_bar_at_bottom = true,

        -- General
        inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
        window_background_opacity = 0.9,
        window_close_confirmation = "NeverPrompt",
        window_frame = {
          active_titlebar_bg = "#45475a",
          font = font_with_fallback(font_name, { bold = true })
        },
      }
    '';

    colorSchemes = {
      rose-pine = ''
        ansi = ["#000000", "#cc0000", "#009600", "#d06b00", "#0000cc", "#cc00cc", "#0087cc", "#cccccc"]
        brights = ["#7f7f7f", "#cc0000", "#009600", "#d06b00", "#0000cc", "#cc00cc", "#0087cc", "#ffffff"]
        foreground = "#cccccc"
        background = "#000000"
        cursor_bg = "#cccccc"
        cursor_border = "#cccccc"
        cursor_fg = "#000000"
        selection_bg = "#4d4d4d"
        selection_fg = "#cccccc"
      '';
    };

    enableZshIntegration = true;
  };
}
