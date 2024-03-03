{ pkgs, config, ... }:

let
  screenshot-area = pkgs.writeShellScriptBin "screenshot-area" ''
    screenshot_dir="${config.xdg.userDirs.pictures}/screenshots"

    if [ ! -d "$screenshot_dir" ]; then
      mkdir -p "$screenshot_dir"
    fi

    filename="$screenshot_dir/screenshot-$(date +%Y-%m-%d-%H-%M-%S).png"
    file_path="$screenshot_dir/screenshot-latest.png"

    maim -s "$filename"

    notify-send "Screenshot" "Screenshot Taked: $filename" -i "$file_path"
  '';
in {
  home.packages = [screenshot-area];
}
