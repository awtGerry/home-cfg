{ pkgs, config, osConfig, ... }:

let
  waybar = pkgs.waybar;
in
{
  programs.waybar = {
    enable = true;
    package = waybar;
    settings = {
      mainBar = {
        ipc = true;
        layer = "bottom";
        position = "top";
        height = 32;
        modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
        modules-center = [ "cpu" "memory" "disk" "network" ];
        modules-right = [ "tray" "idle_inhibitor" "wireplumber" "clock" ];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = ''<span font="Font Awesome 6 Brands"></span>'';
            "2" = ''<span font="Font Awesome 6 Brands"></span>'';
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "7" = "7";
            "8" = ''<span font="Font Awesome 6 Brands"></span>'';
            "9" = ''<span font="Font Awesome 6 Brands"></span>'';
            "10" = ''<span font="Font Awesome 6 Brands"></span>'';
            default = ''<span font="Font Awesome 6 Brands"></span>'';
          };
        };

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "tray" = {
          spacing = 5;
        };

        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%a %b %d, %Y}";
          interval = 1;
          tooltip-format = "{:%a %b %d, %Y | %H:%M:%S}";
        };

        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };

        "memory" = {
          format = "{}% ";
        };

        "disk" = {
          format = "{percentage_used}% ";
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} = {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
        };

        "wireplumber" = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = [ "" "" "" ];
        };
      };
    };

    style = ./style.css;
  };

  home.packages = with pkgs; [
    font-awesome_6
    wireplumber
  ];
}
