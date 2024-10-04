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
        # Until I get used to gl gh (it does makes more sense)
        "$" = "goto_line_end";
        "V" = "extend_line_below"; # TODO: Check what 'V' is used for on helix.
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

        typescript-language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
          ];
        };
      };

      language =
        let
          jsts-ls = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
          ];
          vscode-lsp = [ { name = "vscode-langservers-extracted"; } ];
        in
        [
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
          {
            name = "c";
            auto-format = false; # I only want to format on C when i tell helix to do it.
          }
          {
            name = "bash";
            auto-format = true;
            file-types = [
              "sh"
              "bash"
            ];
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
            };
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = jsts-ls;
          }
          {
            name = "javascript";
            auto-format = true;
            language-servers = jsts-ls;
          }
          {
            name = "html";
            auto-format = true;
            language-servers = vscode-lsp;
            file-types = [
              "html"
              "css"
              "json"
            ];
          }
        ];
    };
  };
}
