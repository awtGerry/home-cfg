{ pkgs, config, ... }:

let
  # rofi menu
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    screenshot_dir="${config.xdg.userDirs.pictures}/screenshots"
    if [ ! -d "$screenshot_dir" ]; then
      mkdir -p "$screenshot_dir"
    fi

    file_path="$screenshot_dir/screenshot-latest.png"

    case "$(printf "  Area\\n  Window\\n󰍹  Full Screen\\n" | rofi -dmenu -i -mesg "Screenshot menu" -config ~/Dev/public/home-cfg/package/rofi/config/opt_menu.rasi)" in
      "  Area")
        file_name="ssarea-$(date +%Y-%m-%d_%H-%M-%S).png"
        maim -s "$screenshot_dir/$file_name"
        ;;
      "  Window")
        file_name="sswindow-$(date +%Y-%m-%d_%H-%M-%S).png"
        maim -i $(xdotool getactivewindow) "$screenshot_dir/$file_name"
        ;;
      "󰍹  Full Screen")
        file_name="ssfull-$(date +%Y-%m-%d_%H-%M-%S).png"
        maim "$screenshot_dir/$file_name"
        ;;
    esac
  '';
in {
  home.packages = [screenshot];
}
