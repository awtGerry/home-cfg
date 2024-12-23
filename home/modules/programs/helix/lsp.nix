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
      auto-pairs = {
        "<" = ">";
        "'" = "'";
      };
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
          formatter = prettier lang;
        }
      )
      [
        "css"
        "scss"
        "html"
        "json"
        "vue"
        "markdown"
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
        (mkLanguage { name = "c"; })
        (mkLanguage { name = "markdown"; })
        (mkLanguage {
          name = "nix";
          langServer = "nil";
        })
        (mkLanguage {
          name = "ruby";
          langServer = "solargraph";
        })
      ] ++ prettierLanguages;

      language-server = {
        biome-lsp = {
          command = "biome";
          args = [ "lsp-proxy" ];
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
        rust-analyzer = {
          config = {
            procMacro.ignored = {
              leptos_macro = [
                "component"
                "server"
              ];
            };
          };
        };
        solargraph = {
          command = "${pkgs.rubyPackages.solargraph}/bin/solargraph";
          config.diagnostics = true;
          config.formatting = true;
        };
      };
    };
  };
}
