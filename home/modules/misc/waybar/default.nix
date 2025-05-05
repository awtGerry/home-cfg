_:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.waybar;
in
{
  config = lib.mkIf cfg.enable {
    programs.waybar.settings = {
      mainBar = {
        ipc = true;
        reload_style_on_change = true;
        layer = "top";
        position = "bottom";
        height = 42;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "cpu"
          "memory"
          "disk"
        ];
        modules-right = [
          "tray"
          "group/language"
          "network"
          "wireplumber"
          "clock"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
            default = ''<span font="Font Awesome 6 Brands"></span>'';
          };
        };

        "hyprland/window" = {
          format = "<span style=\"italic\">- {}</span>";
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
          tooltip = false;
        };

        "disk" = {
          format = "{percentage_used}% ";
          tooltip = false;
        };

        "group/language" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            children-class = "not-power";
            transition-left-to-right = false;
            click-to-reveal = true;
          };

          modules = [
            "custom/lang"
            "custom/lang-us"
            "custom/lang-es"
          ];
        };

        "custom/lang" = {
          format = ''<span font="Font Awesome 6 Brands"></span>'';
          tooltip = false;
        };

        "custom/lang-us" = {
          format = " us ";
          tooltip = false;
          on-click = "hyprctl keyword input:kb_layout us && notify-send 'Keyboard layout' 'Changed layout to: English'";
        };

        "custom/lang-es" = {
          format = " es ";
          tooltip = false;
          on-click = "hyprctl keyword input:kb_layout es && notify-send 'Keyboard layout' 'Changed layout to: Spanish'";
        };

        "network" = {
          format-wifi = ''<span font="Font Awesome 6 Brands"></span>'';
          format-ethernet = ''<span font="Font Awesome 6 Brands"></span>'';
          format-disconnected = ''<span font="Font Awesome 6 Brands"></span>'';
          tooltip = true;
          tooltip-format = "{ifname} = {ipaddr}/{cidr}";
          on-click = "sudo nmtui";
        };

        "wireplumber" = {
          format = "{icon}";
          format-muted = ''<span font="Font Awesome 6 Brands"></span>'';
          format-icons = [
            ''<span font="Font Awesome 6 Brands"></span>''
            ''<span font="Font Awesome 6 Brands"></span>''
            ''<span font="Font Awesome 6 Brands"></span>''
          ];
          tooltip = true;
          tooltip-format = "{volume}%";
          on-click = "${config.apps.terminal} -e pulsemixer";
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "wlogout";
        };

      };

    };

    # TODO: Crear la variante para el tema claro
    programs.waybar.style =
      if config.theme.variant == "light" then ./style_light.css else ./style_dark.css;

    home.packages = [
      pkgs.font-awesome_6
      pkgs.wireplumber
    ];
  };
}
