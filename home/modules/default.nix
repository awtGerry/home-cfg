{
  awt.homeModules = {
    "profiles" = ./profiles;
    "profiles/base" = ./profiles/base;
    "profiles/development" = ./profiles/development;
    "profiles/browsing" = ./profiles/browsing;
    "profiles/gaming" = ./profiles/gaming;

    "programs/nixpkgs" = ./programs/nixpkgs;
    "programs/ghostty" = ./programs/ghostty;
    "programs/helix" = ./programs/helix;
    "programs/helix/lsp" = ./programs/helix/lsp.nix;
    "programs/scripts" = ./programs/scripts;
    "programs/zathura" = ./programs/zathura;
    "programs/zsh" = ./programs/zsh;

    "misc/hyprland" = ./misc/hyprland;
    "misc/waybar" = ./misc/waybar;
    "misc/home" = ./misc/home;
    "misc/rofi" = ./misc/rofi;
    "misc/rofi/config" = ./misc/rofi/config;

    "global" = ./global;
  };
}
