{ lib, config, ... }:

{
  # https://github.com/EdenEast/nightfox.nvim/blob/main/extra/nightfox/base16.yaml
  options.home.colorscheme = lib.mkOption {
    type = lib.types.attrsOf lib.types.string;
    default = {
      base00 = "#192330";
      base01 = "#212e3f";
      base02 = "#29394f";
      base03 = "#575860";
      base04 = "#71839b";
      base05 = "#cdcecf";
      base06 = "#aeafb0";
      base07 = "#e4e4e5";
      base08 = "#c94f6d";
      base09 = "#f4a261";
      base0A = "#dbc074";
      base0B = "#81b29a";
      base0C = "#63cdcf";
      base0D = "#719cd6";
      base0E = "#9d79d6";
      base0F = "#d67ad2";
    };
  };
}
