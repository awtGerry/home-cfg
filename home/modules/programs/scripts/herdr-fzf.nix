{ pkgs, lib, config, ... }:

let
  repoRoots = lib.escapeShellArgs [
    config.dirs.publicRepos
    config.dirs.privateRepos
    config.dirs.work
  ];

  herdr-fzf = pkgs.writeShellApplication {
    name = "herdr-fzf";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      fzf
      jq
    ];
    text = ''
      if (( $# > 1 )); then
        echo "usage: herdr-fzf [repository]" >&2
        exit 2
      fi

      if ! command -v herdr >/dev/null 2>&1; then
        echo "herdr-fzf: herdr is not available in PATH" >&2
        exit 127
      fi

      if (( $# == 1 )); then
        selected="$1"
      else
        repo_roots=(${repoRoots})
        existing_roots=()

        for root in "''${repo_roots[@]}"; do
          if [[ -d "$root" ]]; then
            existing_roots+=("$root")
          fi
        done

        if (( ''${#existing_roots[@]} == 0 )); then
          echo "herdr-fzf: none of the configured repository roots exist" >&2
          exit 1
        fi

        candidate_file="$(mktemp)"
        trap 'rm -f -- "$candidate_file"' EXIT

        if ! find "''${existing_roots[@]}" -mindepth 1 -maxdepth 1 -type d -print0 >"$candidate_file"; then
          echo "herdr-fzf: failed to enumerate repositories" >&2
          exit 1
        fi

        if selected="$(fzf --read0 <"$candidate_file")"; then
          :
        else
          fzf_status=$?
          if (( fzf_status == 1 || fzf_status == 130 )); then
            exit 0
          fi

          echo "herdr-fzf: fzf failed with status $fzf_status" >&2
          exit "$fzf_status"
        fi
      fi

      if [[ -z "$selected" ]]; then
        exit 0
      fi

      requested="$selected"
      if ! selected="$(realpath -e -- "$requested" 2>/dev/null)" || [[ ! -d "$selected" ]]; then
        echo "herdr-fzf: repository is not a directory: $requested" >&2
        exit 1
      fi

      if ! snapshot="$(herdr api snapshot)"; then
        echo "herdr-fzf: failed to read the Herdr session snapshot" >&2
        exit 1
      fi

      if ! jq -e '
        (.result.snapshot.panes | type == "array")
        and all(
          .result.snapshot.panes[];
          type == "object"
          and ((.workspace_id? | type) == "string")
          and (.workspace_id | length > 0)
        )
      ' >/dev/null 2>&1 <<<"$snapshot"; then
        echo "herdr-fzf: Herdr returned an incompatible session snapshot" >&2
        exit 1
      fi

      if ! workspace_id="$(
        jq -r --arg path "$selected" '
          [
            .result.snapshot.panes[]
            | select(type == "object")
            | select(.cwd? == $path or .foreground_cwd? == $path)
            | select((.workspace_id? | type) == "string" and (.workspace_id | length > 0))
            | .workspace_id
          ][0] // empty
        ' 2>/dev/null <<<"$snapshot"
      )"; then
        echo "herdr-fzf: Herdr returned an incompatible session snapshot" >&2
        exit 1
      fi

      if [[ -n "$workspace_id" ]]; then
        if ! herdr workspace focus "$workspace_id"; then
          echo "herdr-fzf: failed to focus workspace $workspace_id" >&2
          exit 1
        fi
        exit 0
      fi

      label="$(basename -- "$selected")"
      if ! herdr workspace create --cwd "$selected" --label "$label" --focus; then
        echo "herdr-fzf: failed to create a workspace for $selected" >&2
        exit 1
      fi
    '';
  };
in
{
  home.packages = [ herdr-fzf ];
}
