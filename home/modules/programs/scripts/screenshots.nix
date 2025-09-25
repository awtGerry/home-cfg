{ pkgs, config, ... }:

let
  cmd =
    # rofi case (X11)
    if config.apps.launcher == "rofi" then
      "${config.apps.launcher} -dmenu -i -mesg \"Screenshot menu\""
    # anyrun case (Wayland)
    else
      "${config.apps.launcher} --plugins libstdin.so --show-results-immediately true --hide-icons true --hide-plugin-info true";

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    screenshot_dir="${config.xdg.userDirs.pictures}/screenshots"
    if [ ! -d "$screenshot_dir" ]; then
      mkdir -p "$screenshot_dir"
      mkdir -p "$screenshot_dir/area"
      mkdir -p "$screenshot_dir/window"
      mkdir -p "$screenshot_dir/full"
    fi

    output=$(date +%Y-%m-%d_%H-%M-%S)
    file_name="screenshot-$output.png"
    xclip_cmd="xclip -sel clip -t image/png"

    case "$(printf "  Area\\n  Window\\n󰍹  Full Screen\\n  Area(clipboard)\\n  Window(clipboard)\\n󰍹  Full Screen(clipboard)" |
      ${cmd})"
    in
      "  Area")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          grim -g "$(slurp)" "$screenshot_dir/area/$file_name"
        else
          maim -s "$screenshot_dir/area/$file_name"
        fi
        notify-send "Screenshot taken" "Screenshot saved to $screenshot_dir/area/$file_name" -i "$screenshot_dir/area/$file_name"
        ;;
      "  Window")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          hyprctl -j activewindow | "${pkgs.jq}/bin/jq" -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - "$screenshot_dir/window/$file_name"
        else
          maim -i $(xdotool getactivewindow) "$screenshot_dir/window/$file_name"
        fi
        notify-send "Screenshot taken" "Screenshot saved to $screenshot_dir/window/$file_name" -i "$screenshot_dir/window/$file_name"
        ;;
      "󰍹  Full Screen")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          active_workspace_monitor=$(hyprctl -j activeworkspace | "${pkgs.jq}/bin/jq" -r '(.monitor)')
          grim -o "$active_workspace_monitor" "$screenshot_dir/full/$file_name"
        else
          maim "$screenshot_dir/full/$file_name"
        fi
        notify-send "Screenshot taken" "Screenshot saved to $screenshot_dir/full$file_name" -i "$screenshot_dir/full/$file_name"
        ;;
      "  Area(clipboard)")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          grim -g "$(slurp)" - | wl-copy
        else
          maim -s | $xclip_cmd
        fi
        notify-send "Screenshot taken and copied to clipboard"
        ;;
      "  Window(clipboard)")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          sleep 0.3
          window=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
          grim -g "$window" - | wl-copy
        else
          maim -i $(xdotool getactivewindow) | $xclip_cmd
        fi
        notify-send "Screenshot taken and copied to clipboard"
        ;;
      "󰍹  Full Screen(clipboard)")
        if [ -n "$WAYLAND_DISPLAY" ]; then
          sleep 0.3
          active_workspace_monitor=$(hyprctl -j activeworkspace | jq -r '(.monitor)')
          grim -o "$active_workspace_monitor" - | wl-copy
        else
          maim | $xclip_cmd
        fi
        notify-send "Screenshot taken and copied to clipboard"
        ;;
    esac
  '';
in
{
  home.packages = [ screenshot ];
}
