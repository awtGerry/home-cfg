_:
{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.zsh;

  # Copy token on ~/TOKEN for git to use
  gt = pkgs.writeShellScriptBin "gt" ''
    head -n 1 "${config.dirs.work}/TOKEN" | xclip -selection clipboard && git
  '';
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ starship ];

    programs.zsh = {
      dotDir = "${config.xdg.configHome}/zsh";

      # Un solo compinit, con -d: sin el, deja .zcompdump.<host>.<pid> en ~.
      # globdots va despues de compinit porque este reinicia _comp_options.
      completionInit = ''
        mkdir -p "${config.xdg.cacheHome}/zsh"
        autoload -U compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        compinit -d "${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION"
        _comp_options+=(globdots)
      '';

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
        hf = lib.mkDefault "herdr-fzf";

        # Nix
        update = lib.mkDefault "sudo nixos-rebuild switch";
        nxd = lib.mkDefault "nix develop --command zsh";
        nxs = lib.mkDefault "nix shell --command zsh";
        nxss = lib.mkDefault "nix-shell --command zsh";
        nxe = lib.mkDefault "nix-env -iA";

        # Git
        g = lib.mkDefault "git";
        gt = lib.mkDefault "head -n 1 ${config.dirs.work}/TOKEN | xclip -selection clipboard && git";
        ga = lib.mkDefault "git add";
        gac = lib.mkDefault "git add . && git commit"; # Add all and commit
        gc = lib.mkDefault "git commit"; # Commit
        gca = lib.mkDefault "git commit --amend"; # Change last commit
        gC = lib.mkDefault "git checkout";
        gd = lib.mkDefault "git diff";
        gds = lib.mkDefault "git diff --staged"; # Diff staged
        gf = lib.mkDefault "git fetch";
        gl = lib.mkDefault "git log";
        gP = lib.mkDefault "git push";
        gp = lib.mkDefault "git pull";
        gs = lib.mkDefault "git status";
        gtk = lib.mkDefault "cat ~/TOKEN | xclip -selection clipboard && git"; # Git action with the token xclip

        # Dirs
        cac = lib.mkDefault "cd ~/.cache";
        sc = lib.mkDefault "cd ~/.local/share";
        dvp = lib.mkDefault "cd ~/Dev/public";
        dvs = lib.mkDefault "cd ~/Dev/private";
        dvc = lib.mkDefault "cd ~/Dev/clones";
        dvw = lib.mkDefault "cd ~/Dev/work";
        dvt = lib.mkDefault "cd ~/Dev/tests";

        cl = lib.mkDefault "claude --dangerously-skip-permissions";

        wget = lib.mkDefault "wget --hsts-file=${config.xdg.cacheHome}/wget-hsts";
      };

      initContent = lib.mkBefore ''
        export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"
        export PATH="$HOME/.railway/bin:$PATH"

        export EDITOR="hx"
        export TERMINAL="${config.apps.terminal}"
        export BROWSER="${config.apps.browser}"

        # shortcuts
        bindkey -v
        export KEYTIMEOUT=1
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
