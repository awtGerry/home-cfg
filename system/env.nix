{ lib, config, ... }:

{
  options.home.configDirectory = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/public/home-config/";
  };
  options.home.publicRepos = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/public/";
  };
  options.home.privateRepos = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/private/";
  };
}
