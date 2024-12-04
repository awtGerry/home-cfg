_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
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
      language-server = lib.optional (langServer != null) langServer;
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
  programs.helix.languages = {
    language = [
      (mkLanguage {
        name = "bash";
        formatter.command = "${pkgs.shfmt}/bin/shfmt";
      })
      (mkLanguage { name = "c"; })
      # NOTA: Para sistemas embebidos descomento estas lineas (simplemente para que no cargue de mas cosas lsp!)
      # (mkLanguage {
      #   name = "cpp";
      #   langServer = {
      #     command = "${pkgs.arduino-language-server}/bin/arduino-language-server";
      #     args = [
      #       "--clangd"
      #       "${pkgs.clang-tools}/bin/clangd"
      #     ];
      #   };
      # })
      (mkLanguage {
        name = "json";
        formatter = {
          command = "biome";
          args = [
            "format"
            "json"
          ];
        };
        extraConfig = {
          language-servers = [
            {
              name = "typescript-language-server";
              except-features = [ "format" ];
            }
            "biome-lsp"
          ];
        };
      })
    ] ++ prettierLanguages;
  };
}
