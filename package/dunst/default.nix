{ pkgs, lib, ... }:


{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        width = 400;
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        offset = "15x15";
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 15;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        separator_height = 2;
        frame_width = 2;
        frame_color = "#eb6f92";
        separator_color = "frame";
        corner_radius = 8;
        transparency = 0;
        gap_size = 8;
        line_height = 0;
        notification_limit = 0;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        word_wrap = "yes";
        sort = "yes";
        shrink = "no";
        indicate_hidden = "yes";
        sticky_history = "yes";
        ignore_newline = "no";
        show_indicators = "no";
        stack_duplicates = true;
        always_run_script = true;
        hide_duplicate_count = false;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};
      urgency_critical = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#21202e";
        timeout = 20;
      };
      urgency_normal = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#21202e";
        timeout = 5;
      };
      urgency_low = {
        background = "#1f1d2e";
        foreground = "#e0def4";
        frame_color = "#21202e";
        timeout = 3;
      };
    };
  };
}
