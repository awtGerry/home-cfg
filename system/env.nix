{ lib, config, ... }:

#
{
  options.home.configDirectory = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/public/home-cfg";
  };
  options.home.devDirectory = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev";
  };
  options.home.publicRepos = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/public/";
  };
  options.home.privateRepos = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Dev/private/";
  };
  options.home.picDir = lib.mkOption {
    type = lib.types.path;
    default = "${config.home.homeDirectory}/Pictures";
  };
  options.home.driveDirectory = lib.mkOption {
    type = lib.types.path;
    default = "/media/Drive";
  };
}
