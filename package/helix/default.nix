{ config, pkgs, lib, ... }:

{
  programs.helix = {
    enable = true;
    package = pkgs.helix;

    settings = {
      theme = "nightfox";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        C-c = [ "keep_primary_selection" "collapse_selection"];
        "$" = "goto_line_end";
        "0" = "goto_line_start";
      };
      keys.insert = {
        C-c = [ "normal_mode" ];
      };
      keys.select = {
        C-c = [ "normal_mode" "keep_primary_selection" "collapse_selection" ];
      };
    };
  };
}
