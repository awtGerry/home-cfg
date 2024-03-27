{ pkgs, config, ... }:

let
  # rofi menu
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    screenshot_dir="${config.xdg.userDirs.pictures}/screenshots"
    if [ ! -d "$screenshot_dir" ]; then
      mkdir -p "$screenshot_dir"
      mkdir -p "$screenshot_dir/area"
      mkdir -p "$screenshot_dir/window"
      mkdir -p "$screenshot_dir/full"
    fi

    file_path="$screenshot_dir/screenshot-latest.png"

    case "$(printf "  Area\\n  Window\\n󰍹  Full Screen\\n  Area(clipboard)\\n  Window(clipboard)\\n󰍹  Full Screen(clipboard)" |
      rofi -dmenu -i -mesg "Screenshot menu" -config ~/Dev/public/home-cfg/package/rofi/config/opt_menu.rasi)"
    in
      "  Area")
        file_name="ssarea-$(date +%Y-%m-%d_%H-%M-%S).png"
        if [ -n "$WAYLAND_DISPLAY" ]; then
          grim -g "$(slurp)" "$screenshot_dir/area/$file_name"
        else
          maim -s "$screenshot_dir/$file_name"
        fi
        notify-send " Screenshot taken" -i "$screenshot_dir/$file_name"
        ;;
      "  Window")
        file_name="sswindow-$(date +%Y-%m-%d_%H-%M-%S).png"
        if [ -n "$WAYLAND_DISPLAY" ]; then
          hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$screenshot_dir/window/$file_name"
        else
          maim -i $(xdotool getactivewindow) "$screenshot_dir/window/$file_name"
        fi
        notify-send " Screenshot taken" -i "$screenshot_dir/$file_name"
        ;;
      "󰍹  Full Screen")
        file_name="ssfull-$(date +%Y-%m-%d_%H-%M-%S).png"
        if [ -n "$WAYLAND_DISPLAY" ]; then
          active_workspace_monitor=$(hyprctl -j activeworkspace | jq -r '(.monitor)')
          grim -o "$active_workspace_monitor" "$screenshot_dir/full/$file_name"
        else
          maim "$screenshot_dir/full/$file_name"
        fi
        notify-send "󰍹 Screenshot taken" -i "$screenshot_dir/$file_name"
        ;;
    esac
  '';
in {
  home.packages = [screenshot];
}
