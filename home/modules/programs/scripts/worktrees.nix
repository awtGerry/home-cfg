{ pkgs, ... }:

# Agentes en paralelo sobre un mismo repo usando git worktrees.
# Ver docs/adr/0001-centralized-agent-host.md y docs/agent-host.md.
#
# wt-agent <nombre> [agente]  -> crea .worktrees/<nombre> (rama agent/<nombre>)
#                                y abre una ventana de tmux corriendo el agente.
# wt-done  <nombre> [--force] -> quita la ventana, el worktree y la rama.
let
  # Raiz del repo principal, funcione o no desde dentro de un worktree.
  find-repo = ''
    common=$(cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd)
    if [[ -z $common ]]; then
      echo "wt: no estas dentro de un repo git" >&2
      exit 1
    fi
    repo=$(dirname "$common")
    session=$(basename "$repo" | tr . _)
  '';

  wt-agent = pkgs.writeShellScriptBin "wt-agent" ''
    #!/usr/bin/env bash
    if [[ $# -lt 1 ]]; then
      echo "uso: wt-agent <nombre> [agente]   # agente: opencode (default) | claude" >&2
      exit 1
    fi

    name="$1"
    agent="''${2:-opencode}"

    ${find-repo}

    path="$repo/.worktrees/$name"
    branch="agent/$name"

    if [[ ! -d $path ]]; then
      if git show-ref --verify --quiet "refs/heads/$branch"; then
        git worktree add "$path" "$branch" || exit 1
      else
        git worktree add "$path" -b "$branch" || exit 1
      fi
    fi

    if ! tmux has-session -t="$session" 2>/dev/null; then
      tmux new-session -ds "$session" -c "$repo"
    fi

    if ! tmux list-windows -t "$session" -F '#W' | grep -qx "$name"; then
      tmux new-window -dt "$session:" -n "$name" -c "$path"
      tmux send-keys -t "$session:$name" "$agent" Enter
    fi

    if [[ -n ''${TMUX:-} ]]; then
      tmux switch-client -t "$session" 2>/dev/null || true
      tmux select-window -t "$session:$name"
    else
      echo "listo: tmux a -t $session  (ventana: $name)"
    fi
  '';

  wt-done = pkgs.writeShellScriptBin "wt-done" ''
    #!/usr/bin/env bash
    if [[ $# -lt 1 ]]; then
      echo "uso: wt-done <nombre> [--force]" >&2
      exit 1
    fi

    name="$1"
    force=""
    [[ "''${2:-}" == "--force" ]] && force="--force"

    ${find-repo}

    path="$repo/.worktrees/$name"
    branch="agent/$name"

    # Orden importante: primero git, al final la ventana
    # (podemos estar parados en ella).
    if [[ -d $path ]]; then
      git worktree remove $force "$path" || {
        echo "wt-done: worktree con cambios; usa --force para descartarlos" >&2
        exit 1
      }
    fi

    if git show-ref --verify --quiet "refs/heads/$branch"; then
      git branch -D "$branch"
    fi

    tmux kill-window -t "$session:$name" 2>/dev/null || true
  '';
in
{
  # Los worktrees de agentes no deben aparecer en git status.
  xdg.configFile."git/ignore".text = ".worktrees/\n";

  home.packages = [
    wt-agent
    wt-done
  ];
}
