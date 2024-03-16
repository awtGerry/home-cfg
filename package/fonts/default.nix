{ inputs, lib, pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # Fonts
    fira-code-nerdfont
    font-awesome
    inter
    open-sans
    ostrich-sans
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];
}
