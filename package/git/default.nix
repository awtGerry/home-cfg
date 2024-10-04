{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Victor Rodriguez";
    userEmail = "awtGerry@gmail.com";

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = "merges";
      rebase.autostash = true;
      diff.algorithm = "histogram";

    }; # extraConfig

    ignores = [
      ".test"
      ".envrc"
      ".project"
      ".settings"
    ];

  };
}
