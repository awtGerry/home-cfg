{ ghostty, ... }:
_: {
  xdg.configFile."ghostty/config".text =
    # toml
    ''
      font-family = "Fira Code"
      font-size = 18

      theme = "GruvboxDarkHard"

      confirm-close-surface = false
      # gtk-titlebar = false
    '';

  home.packages = [ ghostty.packages.x86_64-linux.default ];
}
