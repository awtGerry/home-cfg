{ config, pkgs, lib, ... }:

{
  programs.cava = {
    enable = true;
    settings = {
      general = {
        mode = "normal";
        framerate = 60;
        autosens = 1;
        overshoot = 20;
        sensitivity = 50;
        bars = 0;
        bar_width = 2;
        bar_spacing = 1;
        bar_height = 32;
        lower_cutoff_freq = 50;
        higher_cutoff_freq = 10000;
        sleep_timer = 0;
      };
      input = {
        method = "pulse";
        source = "auto";
      };
      output = {
        channels = "stereo";
        mono_option = "average";
        reverse = 0;
        raw_target = "/dev/stdout";
        data_format = "binary";
        bit_format = "16bit";
        ascii_max_range = 1000;
        bar_delimiter = 59;
        frame_delimiter = 10;
        sdl_width = 1000;
        sdl_height = 500;
        sdl_x = -1;
        sdl_y = -1;
      };
      color = {
        background = "'#192330'";
        foreground = "'#cdcecf'";
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#7ad5d6'";
        gradient_color_2 = "'#63cdcf'";
        gradient_color_3 = "'#86abdc'";
        gradient_color_4 = "'#719cd6'";
        gradient_color_5 = "'#d6d6d7'";
        gradient_color_6 = "'#cdcecf'";
      };
      smoothing = {
        integral = 77;
        monstercat = 0;
        waves = 0;
        gravity = 100;
        ignore = 0;
        noise_reduction = 0.75;
      };
      eq = {
        "1" = 1;
        "2" = 1;
        "3" = 1;
        "4" = 1;
        "5" = 1;
      };
    };
  };
}
