{ config, pkgs, ... }:

let
  settingsFormat = pkgs.formats.yaml { };
in
{
  imports = [
    ../../system/env.nix
  ];

  home.packages = with pkgs; [
    lutris-free
  ];

  xdg.configFile = {
    # Manage lutris config outside of home-manager while keeping track of the files in this git repo
    # "lutris/lutris.conf".source = config.lib.file.mkOutOfStoreSymlink
    #   "${config.home.configDirectory}/package/lutris/config/lutris.conf";

    # Manage lutris game configs outside of home-manager while keeping track of the files in this git repo
    # "lutris/games".source = config.lib.file.mkOutOfStoreSymlink
    #   "${config.home.configDirectory}/package/lutris/config/games";

    # Wii Emulator
    "lutris/runners/dolphin.yml".source = settingsFormat.generate "dolphin.yml" {
      dolphin = {
        nogui = true;
        runner_executable = "${pkgs.dolphinEmuMaster}/bin/dolphin-emu";
      };

      system = {
        disable_runtime = true;

        # Dolphin doesn't work on Wayland - force X11
        env = {
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_QPA_PLATFORM = "xcb";
        };

        prefix_command = "wrap-scale-off"; # Wrap scale off for wayland only x11 breaks lutris
      };
    };

    "lutris/runners/linux.yml".source = settingsFormat.generate "linux.yml" {
      linux = { };

      system = {
        disable_runtime = true;
      };
    };

    # N64 Emulator
    "lutris/runners/mupen64plus.yml".source = settingsFormat.generate "mupen64plus.yml" {
      mupen64plus = {
        runner_executable = "${pkgs.mupen64plus}/bin/mupen64plus";
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
    "lutris/runners/yuzu.yml".source = settingsFormat.generate "yuzu.yml" {
      yuzu = {
        runner_executable = "${pkgs.yuzu}/bin/yuzu";
      };

      system = {
        disable_runtime = true;
      };
    };

    # Redream Dreamcast Emulator
    # "lutris/runners/redream.yml".source = settingsFormat.generate "redream.yml" {
    #   redream = {
    #     runner_executable = "${pkgs.redream}/bin/redream";
    #   };
    #
    #   system = {
    #     disable_runtime = true;
    #   };
    # };

    # PS2 Emulator
    "lutris/runners/pcsx2.yml".source = settingsFormat.generate "pcsx2.yml" {
      pcsx2 = {
        runner_executable = "${pkgs.pcsx2}/bin/pcsx2";
      };

      system = {
        disable_runtime = true;
      };
    };

    # PS3 Emulator
    "lutris/runners/rpcs3.yml".source = settingsFormat.generate "rpcs3.yml" {
      rpcs3 = {
        runner_executable = "${pkgs.rpcs3}/bin/rpcs3";
      };

      system = {
        disable_runtime = true;
      };
    };

    # SNES Emulator
    "lutris/runners/snes9x.yml".source = settingsFormat.generate "snes9x.yml" {
      snes9x = {
        runner_executable = "${pkgs.snes9x}/bin/snes9x";
      };

      system = {
        disable_runtime = true;

        # Snes doesn't work on Wayland - force X11
        env = {
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_QPA_PLATFORM = "xcb";
        };
      };
    };

    # Steam
    "lutris/runners/steam.yml".source = settingsFormat.generate "steam.yml" {
      steam = { };

      system = {
        disable_runtime = true;

        # I've configured steam to only run gamemode while a game is running
        gamemode = false;
      };
    };

    "lutris/runners/wine.yml".source = settingsFormat.generate "wine.yml" {
      wine = { };

      system = {
        prefix_command = "wrap-scale-off"; # Wrap scale off for wayland only x11 breaks lutris
      };
    };
  };
}

