# Pasar ghostty por el momento
{ ghostty, ... }:
_: {
  xdg.configFile."ghostty/config".text =
    # toml
    ''
      font-family = "Fira Code";

      ## uncomment once keybindings have been set to something I am familiar
      ## with. The bar contains the menu, which I need for splits for now…
      # gtk-titlebar = false

      theme = "catppuccin-frappe"
    '';

  home.packages = [ ghostty.packages.x86_64-linux.default ];
}
