_:
{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.zsh;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ starship ];

    programs.zsh = {
      history.size = 10000000;
      history.path = "/home/gerry/.cache/zsh_history";

      shellAliases = {
        ls = lib.mkForce "lsd -h --color=auto --group-directories-first";
        ll = lib.mkForce "lsd -lh --color=auto --group-directories-first";
        shadps4n = lib.mkDefault "appimage-run ~/Games/Shadps4-qt.AppImage";
        e = lib.mkDefault "hx";
        mv = lib.mkDefault "mv -iv";
        rm = lib.mkDefault "rm -vI";
        cat = lib.mkDefault "bat";
        t = lib.mkDefault "tmux";
        neofetch = lib.mkDefault "neofetch --$TERM";
        ta = lib.mkDefault "tmux a";
        z = lib.mkDefault "zathura";
        ff = lib.mkDefault "tmux-fzf";

        # Nix
        update = lib.mkDefault "sudo nixos-rebuild switch";
        nxd = lib.mkDefault "nix develop --command zsh";
        nxs = lib.mkDefault "nix shell --command zsh";
        nxss = lib.mkDefault "nix-shell --command zsh";
        nxe = lib.mkDefault "nix-env -iA";

        # Git
        lg = lib.mkDefault "lazygit"; # Trying lazygit (finally)
        g = lib.mkDefault "git";
        ga = lib.mkDefault "git add";
        gac = lib.mkDefault "git add . && git commit"; # Add all and commit
        gc = lib.mkDefault "git commit"; # Commit
        gca = lib.mkDefault "git commit --amend"; # Change last commit
        gC = lib.mkDefault "git checkout"; # Checkout
        gd = lib.mkDefault "git diff"; # Diff
        gds = lib.mkDefault "git diff --staged"; # Diff staged
        gf = lib.mkDefault "git fetch"; # Fetch
        gl = lib.mkDefault "git log"; # Log
        gP = lib.mkDefault "git push"; # Push
        gp = lib.mkDefault "git pull"; # Pull
        gs = lib.mkDefault "git status"; # Status

        # Dirs
        cac = lib.mkDefault "cd ~/.cache";
        sc = lib.mkDefault "cd ~/.local/share";
        dvp = lib.mkDefault "cd ~/Dev/public";
        dvs = lib.mkDefault "cd ~/Dev/private";
        dvc = lib.mkDefault "cd ~/Dev/clones";
        dvw = lib.mkDefault "cd ~/Dev/work";
        dvt = lib.mkDefault "cd ~/Dev/tests";
      };

      initContent = lib.mkBefore ''
        export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"

        export EDITOR="hx"
        export TERMINAL="${config.apps.terminal}"
        export BROWSER="${config.apps.browser}"

        # Autocomplete with tab
        autoload -U compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit
        _comp_options+=(globdots)

        # shortcuts
        bindkey -v
        export KEYTIMEOUT=1

        # Clean ~
        export XDG_CONFIG_HOME="$HOME/.config"
        export XDG_DATA_HOME="$HOME/.local/share"
        export XDG_CACHE_HOME="$HOME/.cache"

        export CARGO_HOME="$XDG_DATA_HOME/cargo"
        export PATH="$PATH:$CARGO_HOME/bin"
        export GOPATH="$XDG_DATA_HOME/go"
        export PATH=$PATH:$GOPATH/bin
        export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
      '';

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma-continuum";
            repo = "fast-syntax-highlighting";
            rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
            sha256 = "1bmrb724vphw7y2gwn63rfssz3i8lp75ndjvlk5ns1g35ijzsma5";
          };
        }
      ];
      autosuggestion.enable = true;
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        character = {
          success_symbol = "➜";
          error_symbol = "";
        };
      };
    };
  };
}
