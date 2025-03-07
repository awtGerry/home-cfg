_:
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.gaming;
  settingsFormat = pkgs.formats.yaml { };
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.profiles.gaming = {
    enable = lib.mkEnableOption "Activa algunos programas y configuraciones para jugadores";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.allowedUnfree = [
      "discord"
      "steam"
      "steam-run"
      "snes9x"
    ];
    home.packages = with pkgs; [
      discord
      # Paquetes para los controles
      xpad
      # xboxdrv # discontinued

      # Informacion y mejoras
      goverlay
      gamemode
      gamescope
      mangohud
      mesa-demos
      vulkan-tools
      vkBasalt

      # Games & Launchers
      lutris-free
      prismlauncher
      protontricks
      eww
      ukmm
      heroic

      # Emulators
      dolphin-emu
      wineWowPackages.staging
      winetricks
      snes9x
      shadps4
      ryujinx # Emulador para switch
      inputs.self.packages.${pkgs.system}.sudachi
      xemu
      # inputs.self.packages.${pkgs.system}.extract-xiso

      # Game dependencies
      xorg.libXtst
      xorg.libXrender
      xorg.libXext
    ];

    # Configuracion de lutris
    xdg.configFile = {
      "lutris/lutris.conf".source =
        symlink "${config.dirs.repoDir}/home/modules/profiles/gaming/lutris.conf";

      # Nintendo 64 Emulator
      "lutris/runners/mupen64plus.yml".source = settingsFormat.generate "mupen64plus.yml" {
        mupen64plus = {
          runner_executable = "${pkgs.mupen64plus}/bin/mupen64plus";
        };

        system = {
          disable_runtime = true;

          env = {
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_QPA_PLATFORM = "xcb";
          };
        };
      };

      # Wii Emulator
      "lutris/runners/dolphin.yml".source = settingsFormat.generate "dolphin.yml" {
        dolphin = {
          nogui = true;
          runner_executable = "${pkgs.dolphin-emu}/bin/dolphin-emu";
        };

        system = {
          disable_runtime = true;

          # Dolphin doesn't work on Wayland - force X11
          env = {
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_QPA_PLATFORM = "xcb";
          };
        };
      };

      # SNES
      "lutris/runners/snes9x.yml".source = settingsFormat.generate "snes9x.yml" {
        snes9x = {
          nogui = true;
          runner_executable = "${pkgs.snes9x}/bin/snes9x";
        };

        system = {
          disable_runtime = true;
        };
      };

      # Wii U Emulator
      "lutris/runners/cemu.yml".source = settingsFormat.generate "cemu.yml" {
        cemu = {
          runner_executable = "${pkgs.cemu}/bin/cemu";
        };

        system = {
          disable_runtime = true;
        };
      };

      # Nintendo Switch Emulator
      "lutris/runners/ryujinx.yml".source = settingsFormat.generate "ryujinx.yml" {
        ryujinx = {
          # runner_executable = "${pkgs.ryujinx}/bin/ryujinx";
          # Por ahora usare sudachi
          # TODO: Ver si hay una manera de agregar un runner no listado a lutris
          # runner_executable = "/nix/store/cydkw8jjl27ki9qhwccylbrxa8pbf1yq-user-environment/bin/sudachi";
          runner_executable = "${inputs.self.packages.${pkgs.system}.sudachi}/bin/sudachi";
        };

        system = {
          disable_runtime = true;
        };
      };

      # PS2 Emulator
      "lutris/runners/pcsx2.yml".source = settingsFormat.generate "pcsx2.yml" {
        pcsx2 = {
          runner_executable = "${pkgs.pcsx2}/bin/pcsx2-qt";
        };

        system = {
          disable_runtime = true;
        };
      };

      # PS4
      "lutris/runners/shadps4.yml".source = settingsFormat.generate "shadps4.yml" {
        shadps4 = {
          runner_executable = "${pkgs.shadps4}/bin/shadps4";
        };

        system = {
          disable_runtime = true;
        };
      };

      # Xbox emulator
      "lutris/runners/xemu.yml".source = settingsFormat.generate "xemu.yml" {
        xemu = {
          runner_executable = "${pkgs.xemu}/bin/xemu";
        };

        system = {
          disable_runtime = true;
        };
      };

      # Libretro Emulator (por ahora lo manejare manual)
      # "lutris/runners/libretro.yml".source = settingsFormat.generate "libretro.yml" {
      #   libretro = {
      #     runner_executable = "${pkgs.retroarch}/bin/retroarch";
      #     config_file = "${config.home.dotfiles}/retroarch/retroarch.cfg";
      #   };
      #   system = {
      #     disable_runtime = true;
      #   };
      # };

      # Steam
      "lutris/runners/steam.yml".source = settingsFormat.generate "steam.yml" {
        steam = { };

        system = {
          disable_runtime = true;
          gamemode = false;
          env = {
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_QPA_PLATFORM = "xcb";
          };
        };
      };

      "lutris/runners/linux.yml".source = settingsFormat.generate "linux.yml" {
        linux = { };

        system = {
          disable_runtime = true;
        };
      };

      "lutris/runners/wine.yml".source = settingsFormat.generate "wine.yml" { wine = { }; };
    };

  };
}
