{
  config,
  pkgs,
  inputs,
  ...
}:
{

  config = {
    activeProfiles = [
      "development"
      "browsing"
      "gaming"
    ];

    theme = {
      variant = "dark";
      # variant = "light";

      # baseScheme = "e-ink";
      baseScheme = "rose_pine";
    };

    apps = {
      browser = "firefox";
      terminal = "ghostty";
      launcher = "anyrun";
      editor = "helix";
      music = "rmpc";
    };

    # Host centralizado de agentes: que un `ld` no congele la maquina
    agents.memoryCap.enable = true;

    # Solo la app de escritorio; el CLI y los gateways siguen en ~/.hermes/hermes-agent
    programs.hermes-agent.desktop.enable = true;

    programs.waybar.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;
      visuals = {
        # Agrega reglas de transparencia (testeando con firefox)
        # transparency = {
        #   enable = true;
        #   opacityRules = {
        #     terminal = {
        #       ghostty = "0.90 0.90";
        #     };
        #   };
        # };
      };
      # Atajos de teclado
      # bindings = {
      #   modKey = "SUPER";
      #   # NOTE: Aqui se pueden añadir atajos de teclado adicionales
      #   # extraBinds = [
      #   #   "$mod, C, exec, code"
      #   #   "$mod SHIFT, V, exec, vlc"
      #   # ];
      # };
    };

    nixpkgs.allowedUnfree = [
      "spotify"
    ];

    home.packages = with pkgs; [
      spotify
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.grok-bot

      # Bot Screen de Hermes: escritorio por bot que se ve y se toma desde la app.
      # `hermes computer-use screen install` solo sabe de apt/dnf/pacman. Sin el metapaquete
      # de xfce4: su salvapantallas y polkit bloquean un escritorio sin monitor.
      tigervnc
      xfwm4
      xfce4-panel
      xfdesktop
      xfce4-settings
      xfce4-terminal
      xfconf # su servicio D-Bus: sin xfconfd, Xfce ignora el dock y el fondo de Hermes
      dbus
      xauth
      xdpyinfo
      setxkbmap
      xprop
      xsetroot
      xset
      dejavu_fonts
    ];

    home.sessionVariables = {
      # Usa Wayland para aplicaciones Chrome & Electron
      NIXOS_OZONE_WL = 1;
      # Mejora la apariencia de aplicaciones de Java
      JDK_JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    };

    dconf.enable = true;
    systemd.user.tmpfiles.rules = [
      "d ${config.home.homeDirectory}/tmp 700 ${config.home.username} users 14d"
    ];
  };
}
