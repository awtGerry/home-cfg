# Notificaciones "glass card": tarjeta translucida arriba a la derecha.
# El blur lo pone Hyprland (layerrules `notifications`); aqui solo hay alpha.
_:
{
  config,
  lib,
  ...
}:
let
  cfg = config.wayland.windowManager.hyprland;

  # Paleta de waybar (style_dark.css)
  palette = {
    bg = "#0c1110";
    fg = "#dfe4e7";
    fgMuted = "#a9b5bf";
    accent = "#172a27";
    frame = "#2f6f64";
    red = "#eb4d4b";
  };
  # Alpha en hex: b3 = 70%
  glass = "${palette.bg}b3";
in
{
  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          origin = "top-right";
          offset = "(16, 16)";
          width = "(300, 380)";
          height = "(0, 220)";
          gap_size = 10;
          notification_limit = 5;

          corner_radius = 12;
          frame_width = 1;
          frame_color = palette.frame;
          background = glass;
          foreground = palette.fg;
          separator_color = "frame";
          padding = 14;
          horizontal_padding = 16;

          font = "sans-serif 10";
          format = "<b>%s</b>\\n%b";
          markup = "full";
          alignment = "left";

          icon_position = "left";
          min_icon_size = 40;
          max_icon_size = 56;
          icon_corner_radius = 8;

          progress_bar = true;
          progress_bar_height = 8;
          progress_bar_frame_width = 0;
          progress_bar_corner_radius = 4;

          timeout = 6;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          background = glass;
          foreground = palette.fgMuted;
          frame_color = palette.accent;
          timeout = 4;
        };
        urgency_normal = {
          background = glass;
          foreground = palette.fg;
          frame_color = palette.frame;
          timeout = 6;
        };
        urgency_critical = {
          background = glass;
          foreground = palette.fg;
          frame_color = palette.red;
          timeout = 0;
        };
      };
    };
  };
}
