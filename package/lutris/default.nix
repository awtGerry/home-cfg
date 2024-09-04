{ config, pkgs, ... }:

let
  settingsFormat = pkgs.formats.yaml { };
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../system/env.nix
  ];

  home.packages = with pkgs; [
    lutris-free
  ];

  xdg.configFile = {
    "lutris/lutris.conf".source = symlink "${config.home.configDirectory}/package/lutris/config/lutris.conf";
    # "lutris/games".source = symlink "${config.home.configDirectory}/package/lutris/config/games";

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
        runner_executable = "${pkgs.dolphinEmuMaster}/bin/dolphin-emu";
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
        runner_executable = "${pkgs.ryujinx}/bin/ryujinx";
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

    # Libretro Emulator (for now we handle it manually)
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

    "lutris/runners/wine.yml".source = settingsFormat.generate "wine.yml" {
      wine = { };
    };
  };
}

