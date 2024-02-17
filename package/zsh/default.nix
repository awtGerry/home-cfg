{ pkgs, ...}:

let
  zsh = pkgs.zsh;
in
{
  programs.zsh = {
    enable = true;

    history.size=10000000;
    history.path="/home/gerry/.cache/zsh_history";

    shellAliases = {
      ls="lsd -h --color=auto --group-directories-first";
      ll="lsd -lh --color=auto --group-directories-first";
      mv="mv -iv";
      rm="rm -vI";
      cat="bat";
      npm="npm --no-fund --no-audit";
      v="nvim";
      t="tmux";
      ta="tmux a";
      z="zathura";
      ff="~/Dev/public/home-cfg/package/tmux/tmux-fzf.sh";
      update="sudo nixos-rebuild switch";
    };

    initExtra = ''
      export PATH="$PATH:$(find ~/.local/bin -type d | paste -sd ':' -)"

      export EDITOR="nvim"
      export TERMINAL="kitty"

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
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        # src = pkgs.fetchFromGitHub {
        #   owner = "romkatv";
        #   repo = "powerlevel10k";
        #   rev = "d804048efc46b8b248693fa3a7bfc9f863bb1254";
        #   sha256 = "0q7sachpvxaki983q8p7dkjbx6igab3g00vy3yfjb4yzxxz8dhb1";
        # };
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    enableAutosuggestions = true;
  };
}
