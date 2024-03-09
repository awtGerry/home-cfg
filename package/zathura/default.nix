{ pkgs, config, ...}:

{
  programs.zathura = {
    enable = true;
    package = pkgs.zathura;

    options = {
      sandbox = "none";
      statusbar-h-padding = 0;
      statusbar-v-padding = 0;
      page-padding = 1;
      selection-clipboard = "clipboard";
    };
    
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      p = "print";
      g = "goto top";
    };

    # options = ''
    #   set sandbox none
    #   set statusbar-h-padding 0
    #   set statusbar-v-padding 0
    #   set page-padding 1
    #   set selection-clipboard clipboard
    #   map u scroll half-up
    #   map d scroll half-down
    #   map D toggle_page_mode
    #   map r reload
    #   map R rotate
    #   map K zoom in
    #   map J zoom out
    #   map i recolor
    #   map p print
    #   map g goto top
    # '';
  };
}
