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

      # ignores = [
      #   ".test"
      #   ".envrc"
      #   ".project"
      #   ".settings"
      # ];

    }; # extraConfig

    # home.packages = with pkgs; [
    #   gitAndTools.git-bug
    # ];

  };
}
