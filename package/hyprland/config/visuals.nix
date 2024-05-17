{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 1;
      blur = {
        size = 6;
        passes = 3;
        new_optimizations = true;
        ignore_opacity = true;
        noise = "0.1";
        contrast = "1.1";
        brightness = "1.2";
        xray = true;
      };
      dim_inactive = true;
      dim_strength = "0.3";
      fullscreen_opacity = 1;
      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_offset = "0 8";
      shadow_range = 50;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";
      blurls = ["lockscreen" "waybar" "popups"];
    };
    animation = {
      bezier = [
        "fluent_decel, 0, 0.2, 0.4, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutCubic, 0.33, 1, 0.68, 1"
        "easeinoutsine, 0.37, 0, 0.63, 1"
      ];
      animation = [
        "windowsIn, 1, 1.7, easeOutCubic, slide" # window open
        "windowsOut, 1, 1.7, easeOutCubic, slide" # window close
        "windowsMove, 1, 2.5, easeinoutsine, slide" # everything in between, moving, dragging, resizing

        # fading
        "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
        "fadeOut, 1, 3, easeOutCubic" # fade out (close) -> layers and windows
        "fadeSwitch, 1, 5, easeOutCirc" # fade on changing activewindow and its opacity
        "fadeShadow, 1, 5, easeOutCirc" # fade on changing activewindow for shadows
        "fadeDim, 1, 6, fluent_decel" # the easing of the dimming of inactive windows
        "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
        "workspaces, 1, 2, fluent_decel, slide" # styles: slide, slidevert, fade, slidefade, slidefadevert
        "specialWorkspace, 1, 3, fluent_decel, slidevert"
      ];
    };

    dwindle = {
      no_gaps_when_only = true;
      pseudotile = true;
      preserve_split = true;
    };

    windowrule = [
      "workspace 2, ^(firefox)$"
      "workspace 3, ^(chromium)$"
      "workspace 4, ^(Steam)$"
      "workspace 4, ^(lutris)$"
      "workspace 5, ^(gimp)$"
      "workspace 5, ^(figma)$"
      "workspace 9, ^(thunderbird)$"
      "workspace 10, ^(Spotify)$"
      "workspace 10, ^(Spotify Premium)$"
      "workspace 10, ^(Spotify Free)$"
    ];

    windowrulev2 = [
      # "opacity 0.90 0.90,class:^(kitty)$"
      "opacity 0.90 0.90,class:^(foot)$"
      # "opacity 0.90 0.90,class:^(firefox)$"
      # "opacity 0.90 0.90,class:^(chromium)$"
      "opacity 0.80 0.80,class:^(Steam)$"
      "opacity 0.80 0.80,class:^(steam)$"
      "opacity 0.80 0.80,class:^(steamwebhelper)$"
      "opacity 0.80 0.80,class:^(Spotify)$"
      "opacity 0.80 0.80,class:^(Code)$"
      "opacity 0.80 0.80,class:^(thunar)$"
      "opacity 0.80 0.80,class:^(file-roller)$"
      "opacity 0.80 0.80,class:^(nwg-look)$"
      "opacity 0.80 0.80,class:^(qt5ct)$"
      "opacity 0.80 0.80,class:^(VencordDesktop|Webcord|discord|Discord)"
      "opacity 0.80 0.70,class:^(pavucontrol)$"
      "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "opacity 0.80 0.80,class:^(org.telegram.desktop)$"
      "opacity 0.80 0.80,class:^(code-url-handler)$"
      "opacity 0.80 0.80,title:^(Spotify( Premium)?)$"
      "opacity 0.80 0.80,title:^(Spotify( Free)?)$"
      "opacity 0.80 0.80,title:^(Steam)$"
      "opacity 0.90 0.90, class:^(inlyne)$"

      "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "float,class:^(pavucontrol)$"
      "float,class:^(zathura)$"
      "float,class:^(thunar)$"
      "float,title:^(Media viewer)$"
      "float,title:^(Volume Control)$"
      "float,class:^(Viewnior)$"
      "float,title:^(DevTools)$"
      "float,class:^(file_progress)$"
      "float,class:^(confirm)$"
      "float,class:^(dialog)$"
      "float,class:^(download)$"
      "float,class:^(notification)$"
      "float,class:^(error)$"
      "float,class:^(confirmreset)$"
      "float,title:^(Open File)$"
      "float,title:^(branchdialog)$"
      "float,title:^(Confirm to replace files)$"
      "float,title:^(File Operation Progress)$"
      "float,class:^(com.github.Aylur.ags)$"

      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      "idleinhibit focus, class:^(mpv|.+exe)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit fullscreen, class:^(firefox)$"
      "idleinhibit fullscreen, class:^(Brave-browser)$"

      "dimaround, class:^(xdg-desktop-portal-gtk)$"
      "dimaround, class:^(polkit-gnome-authentication-agent-1)$"

      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"

      "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
      "noanim,class:^(xwaylandvideobridge)$"
      "nofocus,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
      "noblur,class:^(xwaylandvideobridge)$"
      "noshadow,class:^(xwaylandvideobridge)$"
    ];
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      ignorealpha = [
        "calendar"
        "notifications"
        "osd"
        "system-menu"

        "anyrun"
        "popups"
      ];
      layers = ignorealpha ++ ["bar" "gtk-layer-shell"];
    in [
      "blur, ${toRegex layers}"
      "xray 1, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.2, ${toRegex ["bar" "gtk-layer-shell"]}"
      "ignorealpha 0.5, ${toRegex (ignorealpha ++ ["music"])}"
    ];
  };
}
