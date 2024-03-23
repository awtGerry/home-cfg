{ pkgs, ... }:

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
        layer = "top";
        position = "bottom";
        height = 32;
        modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
        modules-center = [ "cpu" "memory" "disk" "temperature" "network" ];
        modules-right = [ "idle_inhibitor" "wireplumber" "clock" "tray" ];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = ''<span font="Font Awesome 6 Brands"></span>'';
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "7" = "7";
            "8" = "8";
            "9" = "";
            "10" = "";
            default = "";
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
          spacing = 10;
        };

        "clock" = {
          format = "{:%H:%M:%S}";
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
          format = "{percentage_used}% ";
        };

        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" "" "" "" "" ];
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname} = {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
        };

        "wireplumber" = {
          format = "{volume}% {icon}";
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
