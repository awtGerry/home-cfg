_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.helix;
  mkLanguage =
    {
      name,
      autoFormat ? true, # Si no se especifica siempre se usara
      langServer ? null,
      formatter ? null,
    }:
    {
      inherit name;
      auto-format = autoFormat;
      # Cerrar cosas
      # auto-pairs = {
      #   "<" = ">";
      #   "'" = "'";
      # };
      language-servers = lib.optional (langServer != null) langServer;
    }
    // (lib.optionalAttrs (formatter != null) { inherit formatter; });

  prettier = lang: {
    command = "${pkgs.nodePackages.prettier}/bin/prettier";
    args = [
      "--parser"
      lang
    ];
  };

  prettierLanguages =
    map
      (
        lang:
        mkLanguage {
          name = lang;
          autoFormat = true;
          formatter = prettier lang;
        }
      )
      [
        "css"
        "scss"
        "html"
        "json"
        "vue"
      ];
in
{
  config = lib.mkIf cfg.enable {
    programs.helix.languages = {
      language = [
        (mkLanguage {
          name = "bash";
          formatter.command = "${pkgs.shfmt}/bin/shfmt";
        })
        (mkLanguage {
          name = "c";
          langServer = "clangd";
        })
        (mkLanguage {
          name = "markdown";
          autoFormat = false;
        })
        (mkLanguage {
          name = "nix";
          langServer = "nil";
        })
        (mkLanguage {
          name = "rust";
          autoFormat = true;
          langServer = "rust-analyzer";
        })
        (mkLanguage {
          name = "lua";
          autoFormat = true;
          langServer = "lua-language-server";
        })
        (mkLanguage {
          name = "ruby";
          langServer = "solargraph";
        })
        (mkLanguage {
          name = "html";
          langServer = "vscode-html-language-server";
        })
        (mkLanguage {
          name = "latex";
          autoFormat = true;
          langServer = "texlab";
        })
      ]
      ++ prettierLanguages;

      language-server = {
        biome-lsp = {
          command = "biome";
          args = [ "lsp-proxy" ];
        };
        vscode-html-language-server = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
        };
        nil = {
          command = "${pkgs.nil}/bin/nil";
          config.nil.formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
        };
        typescript-language-server = {
          command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "tsserver-path=${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
          ];
        };
        solargraph = {
          command = "${pkgs.rubyPackages.solargraph}/bin/solargraph";
          config.diagnostics = true;
          config.formatting = true;
        };
        lua-language-server = {
          command = "${pkgs.lua-language-server}/bin/lua-language-server";
          config = {
            Lua = {
              workspace.library = [
                "${pkgs.lua-language-server}/share/lua-language-server/meta/3rd/love2d/library"
              ];
              runtime.version = "LuaJIT";
            };
          };
        };
        texlab = {
          command = "${pkgs.texlab}/bin/texlab";
          config = {
            texlab = {
              build = {
                onSave = true;
                forwardSearchAfter = true;
                executable = "latexmk";
                args = [
                  "--shell-escape"
                  "-pdf"
                  "-interaction=nonstopmode"
                  "-synctex=1"
                  "%f"
                ];
              };
              forwardSearch = {
                executable = "zathura";
                args = [
                  "--synctex-forward"
                  "%l:1:%f"
                  "%p"
                ];
              };
              chktex = {
                onEdit = true;
              };
            };
          };
        };
      };
    };
  };
}
