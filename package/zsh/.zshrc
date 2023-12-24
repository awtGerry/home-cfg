#!/bin/zsh

# Anadir bin a path
export PATH="$PATH:${$(find ~/.local/bin -type d -printf %p:)%%:}"
# export PATH=$PATH:$(go env GOPATH)/bin

unsetopt PROMPT_SP

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# vim
bindkey -v
export KEYTIMEOUT=1

# Historial en cache
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh_history

# Completar con tab
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Cargar configuraciones & atajos
# Programas
export EDITOR="nvim"
export TERMINAL="wezterm"
export BROWSER="brave"
export MUSIC="spotify"

# shortcuts
bindkey -s '^f' '~/Github/home-cfg/package/tmux/tmux-fzf.sh\n'

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/alias"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/dirs" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/dirs"

# Limpiar $HOME
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PATH="$PATH:$CARGO_HOME/bin"
export GOPATH="$XDG_DATA_HOME/go"
export PATH=$PATH:$GOPATH/bin
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"

# Plugins
# Power level Theme.
source $HOME/.nix-profile/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
# Syntax highlight
source $HOME/.nix-profile/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh 2>/dev/null
