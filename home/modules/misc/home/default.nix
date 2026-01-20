{ self, ... }:
{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  profiles.base.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts =
      let
        cfg = builtins.mapAttrs (
          _: f:
          f
          ++ [
            "Joy Pixels"
            "Noto Color Emoji"
            "FontAwesome"
          ]
        );
      in
      cfg {
        monospace = [ "Noto Sans Mono" ];
        sansSerif = [ "Libertinus Sans" ];
        serif = [ "Libertinus Serif" ];
      };
  };
  nixpkgs.allowedUnfree = [ "joypixels" ];
  nixpkgs.config.joypixels.acceptLicense = true;

  home = {
    packages = with pkgs; [
      hello
      tmate # Comparte terminales

      # Fuentes
      fira-code # dev
      nerd-fonts.monaspace
      libertinus
      joypixels # unfree?
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
    ];

    stateVersion = "23.11";
  };
}
