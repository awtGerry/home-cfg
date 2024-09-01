{ pkgs, lib, config, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        width = 480;
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
        # frame_color = "#eb6f92";
        separator_color = "frame";
        corner_radius = 4;
        transparency = 90;
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
        background = "${config.home.colorscheme.base08}";
        foreground = "${config.home.colorscheme.base05}";
        frame_color = "${config.home.colorscheme.base08}";
        timeout = 20;
      };

      urgency_normal = {
        background = "${config.home.colorscheme.base00}";
        foreground = "${config.home.colorscheme.base05}";
        frame_color = "${config.home.colorscheme.base00}";
        timeout = 10;
      };

      urgency_low = {
        background = "${config.home.colorscheme.base00}";
        foreground = "${config.home.colorscheme.base05}";
        frame_color = "${config.home.colorscheme.base00}";
        timeout = 5;
      };
    };
  };
}
