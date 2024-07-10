{ pkgs, lib, config, ... }:

let
  lf = pkgs.lf;
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    ctpv
    file
    ueberzug
  ];

  imports = [
    ../../system/env.nix
  ];

  xdg.configFile."lf/icons".source = symlink "${config.home.configDirectory}/package/lf/icons";

  programs.lf = {
    enable = true;
    package = lf;

    settings = {
      shellopts = "-eu";
      number = true;
      autoquit = true;
      scrolloff = 10;
      preview = true;
      dirfirst = true;
      hidden = true;
      hiddenfiles = ".*:*.aux:*.log:*.bbl:*.bcf:*.blg:*.run.xml";
      icons = true;
      drawbox = true;
    };

    # TODO: complete commands
    commands = {
      # Open files depending on their type (.jpg -> sxiv, .pdf -> zathura, etc).
      open = ''
        ''${{
        case $(file --mime-type "$(readlink -f $f)" -b) in
          image/*) ${pkgs.sxiv}/bin/sxiv "$f" ;;
          */pdf) ${pkgs.zathura}/bin/zathura "$f" ;;
          text/*) lf -remote "send $id \$$EDITOR \$fx";;
        esac
        }}
      '';
    };

    previewer = {
      keybinding = "i";
      source = "${pkgs.ctpv}/bin/ctpv";
    };

    extraConfig = ''
      &${pkgs.ctpv}/bin/ctpv -s $id
      cmd on-quit %${pkgs.ctpv}/bin/ctpv -e $id
      set cleaner ${pkgs.ctpv}/bin/ctpvclear
    '';

    keybindings = {
      gh = "cd ~";
      gv = "cd ${config.home.devDirectory}";
      gp = "cd ${config.home.picDir}";
      a = "push %mkdir<space>";
      t = "push %touch<space>";
      r = "push :rename<space>";
      D = "push :delete<space>";
      "<enter>" = "open";
    };
  };
}
