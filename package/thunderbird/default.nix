{ lib, pkgs, config, ...}:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird;
    profiles = {
      first = {
        isDefault = true;
        withExternalGnupg = true;
        userChrome = ''
          * { color: blue !important; }
        '';
        userContent = ''
          * { color: red !important; }
        '';
        extraConfig = ''
          user_pref("mail.html_compose", false);
        '';
      };

      second.settings = { "second.setting" = "some-test-setting"; };
    };
  };
}
