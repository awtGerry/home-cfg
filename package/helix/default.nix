{ pkgs, ... }:

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
        C-c = [
          "keep_primary_selection"
          "collapse_selection"
        ];
        "$" = "goto_line_end";
        "0" = "goto_line_start";
      };
      keys.insert = {
        C-c = [ "normal_mode" ];
      };
      keys.select = {
        C-c = [
          "normal_mode"
          "keep_primary_selection"
          "collapse_selection"
        ];
        "$" = "goto_line_end";
        "0" = "goto_line_start";
      };
    };

    languages = {
      language-server = {
        nil =
          let
            nix-ls = pkgs.nil;
            fmt = pkgs.nixfmt-rfc-style;
          in
          {
            command = "${nix-ls}/bin/nil";
            config.nil.formatting = {
              command = [ "${fmt}/bin/nixfmt" ];
            };
          };
      };

      language = [
        {
          name = "nix";
          language-servers = [ "nil" ];
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
      ];
    };
  };
}
