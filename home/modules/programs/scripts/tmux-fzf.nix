{ pkgs, config, ... }:

let
  public_repos = "${config.dirs.publicRepos}";
  private_repos = "${config.dirs.privateRepos}";
  work_dir = "${config.dirs.work}";
  tmux-fzf = pkgs.writeShellScriptBin "tmux-fzf" ''
    #!/usr/bin/env bash
    if [[ $# -eq 1 ]]; then
        selected=$1
    else
        selected=$(find ${public_repos} ${private_repos} ${work_dir} -mindepth 1 -maxdepth 1 -type d | fzf)
    fi

    if [[ -z $selected ]]; then
        exit 1
    fi

    selected_name=$(basename "$selected" | tr . _)
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        exit 0
    fi

    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    else
        tmux attach-session -t $selected_name
    fi

    tmux switch-client -t $selected_name
  '';
in
{
  home.packages = [ tmux-fzf ];
}
