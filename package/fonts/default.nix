{ inputs, lib, pkgs, config, ... }:
{
  home.packages = with pkgs; [
    # Fonts
    fira-code-nerdfont
    libertinus
    noto-fonts-color-emoji
    font-awesome
    inter
    open-sans ostrich-sans
    noto-fonts
    noto-fonts-cjk
    # noto-fonts-emoji
    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "joypixels" ];

  fonts.fontconfig.enable = true;
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
    <fontconfig>
      <alias binding="same">
        <family>serif</family>
        <prefer>
          <family>Libertinus Serif</family>
          <family>Joy Pixels</family>
          <family>Noto Color Emoji</family>
          <family>FontAwesome</family>
        </prefer>
      </alias>
      <alias binding="same">
        <family>sans-serif</family>
        <prefer>
          <family>Libertinus Sans</family>
          <family>Joy Pixels</family>
          <family>Noto Color Emoji</family>
          <family>FontAwesome</family>
        </prefer>
      </alias>
      <alias binding="same">
        <family>sans</family>
        <prefer>
          <family>Libertinus Sans</family>
          <family>Joy Pixels</family>
          <family>Noto Color Emoji</family>
          <family>FontAwesome</family>
        </prefer>
      </alias>
      <alias binding="same">
        <family>monospace</family>
        <prefer>
          <family>Noto Sans Mono</family>
          <family>Joy Pixels</family>
          <family>Noto Color Emoji</family>
          <family>FontAwesome</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

}
