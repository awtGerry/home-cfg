{
  self,
  config,
  ...
}:

{
  config = {
    activeProfiles = [
      "development"
      "browsing"
    ];

    sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    # sops.defaultSopsFile = "${self}/secrets/cerberus/default.yaml";

    theme = {
      variant = "dark";
      baseScheme = "rose_pine";
    };

    # Windows maneja casi todo, voy a especificar wsl para evitar instalaciones no usadas
    apps = {
      browser = "wsl";
      terminal = "wsl";
      editor = "helix"; # Helix si lo necesito
      launcher = "wsl";
      music = "wsl";
    };

    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
