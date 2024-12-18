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
      formatter ? null,
      autoFormat ? true, # Si no se especifica siempre se usara
      langServer ? null,
      extraConfig ? { },
    }:
    {
      inherit name;
      auto-format = autoFormat;
      # Cerrar cosas
      auto-pairs = {
        # Solo me gusta usar estos, {} o () me incomoda...
        "<" = ">";
        "'" = "'";
      };
      # language-servers = lib.optional (langServer != null) langServer;
    }
    // (lib.optionalAttrs (formatter != null) { inherit formatter; })
    // extraConfig;

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
        # (mkLanguage {
        #   name = "ruby";
        #   extraConfig = {
        #     language-server = [
        #       {
        #         name = "solargraph";
        #         args = [ "stdio" ];
        #       }
        #     ];
        #   };
        # })
        # (mkLanguage {
        #   name = "json";
        #   formatter = {
        #     command = "biome";
        #     args = [
        #       "format"
        #       "json"
        #     ];
        #   };
        #   extraConfig = {
        #     language-server = [
        #       {
        #         name = "typescript-language-server";
        #         except-features = [ "format" ];
        #       }
        #       "biome-lsp"
        #     ];
        #   };
        # })
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
      };
    };
  };
}
