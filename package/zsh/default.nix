{ pkgs, ... }:

{

  home.packages = with pkgs; [
    starship # Change to starship
  ];

  programs.zsh = {
    enable = true;

    history.size = 10000000;
    history.path = "/home/gerry/.cache/zsh_history";

    shellAliases = {
      ls = "lsd -h --color=auto --group-directories-first";
      ll = "lsd -lh --color=auto --group-directories-first";
      e = "hx";
      mv = "mv -iv";
      rm = "rm -vI";
      cat = "bat";
      # npm="npm --no-fund --no-audit";
      # pnpm="pnpm --no-fund --no-audit";
      t = "tmux";
      neofetch = "neofetch --$TERM";
      ta = "tmux a";
      z = "zathura";
      ff = "tmux-fzf";

      # Nix
      update = "sudo nixos-rebuild switch";
      nxd = "nix develop --command zsh";
      nxs = "nix shell --command zsh";
      nxss = "nix-shell --command zsh";
      nxe = "nix-env -iA";

      # Git
      lg = "lazygit"; # Trying lazygit (finally)
      g = "git";
      ga = "git add";
      gac = "git add . && git commit"; # Add all and commit
      gc = "git commit"; # Commit
      gca = "git commit --amend"; # Change last commit
      gC = "git checkout"; # Checkout
      gd = "git diff"; # Diff
      gds = "git diff --staged"; # Diff staged
      gf = "git fetch"; # Fetch
      gl = "git log"; # Log
      gP = "git push"; # Push
      gp = "git pull"; # Pull
      gs = "git status"; # Status

      # Dirs
      cac = "cd ~/.cache";
      sc = "cd ~/.local/share";
      dvp = "cd ~/Dev/public";
      dvs = "cd ~/Dev/private";
      dvc = "cd ~/Dev/clones";
      dvw = "cd ~/Dev/work";
      dvt = "cd ~/Dev/tests";
    };

    initExtraFirst = ''
      export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"

      export EDITOR="hx"
      export TERMINAL="wezterm"
      export BROWSER="firefox"

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

    enableAutosuggestions = true;
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
}
