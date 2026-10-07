# ADR 0001: artemis as a centralized agent host

- Status: accepted
- Date: 2026-08-19

## Context

I work from multiple machines (artemis as main, a Windows 11 + WSL work machine,
and eventually others). I want AI coding agents (opencode, claude-code) to keep
running when my connection drops, and I want compilation/installation to happen
on artemis so the other machines stay thin clients that only delegate to agents.

## Decisions

### 1. Plain SSH as the transport

Agents run inside tmux on artemis, which already makes sessions survive
disconnects. Mosh was rejected: it adds UDP requirements (often blocked on
corporate networks) and only buys local echo and roaming, which I don't need.

### 2. Tailscale (hosted control plane) for reachability

Tailscale runs on artemis and on the Windows 11 **host** of the work machine;
WSL2 reaches tailnet machines through the Windows host's network stack, so no
Tailscale daemon runs inside WSL. Self-hosted headscale was rejected: it makes
the coordination server a bootstrap dependency for reaching the very machine
that hosts it.

sshd stays reachable on both the LAN (port 22, already open) and `tailscale0`.
Binding sshd to Tailscale only was rejected: a Tailscale outage would remove
all remote access, even from the local network.

### 3. Key-only SSH with a dedicated client key

`PasswordAuthentication` and `KbdInteractiveAuthentication` are disabled and
root login is refused. The work machine uses a **new, dedicated** ed25519 key
(distinct from the GitHub key already in WSL), committed to this flake under
`users.users.gerry.openssh.authorizedKeys.keys` (via `awt.server.authorizedKeys`).

### 4. Code lives on artemis

Repositories exist only on artemis; other machines are thin clients (terminal +
SSH). Git remains the sync mechanism (`git pull` before starting work, as
already habitual). File-sync alternatives (Syncthing, NFS, sshfs) were rejected:
sync conflicts plus agents editing files that are open locally is worse than
not having local copies.

### 5. Per-repo tmux sessions, multiple agent windows

The existing `tmux-fzf` script already provides one tmux session per repo.
Parallel agents on the same project run as **windows inside the repo session**
(e.g. window `1: opencode`, window `2: claude-code`). No auto-attach on SSH:
the local and remote workflows stay identical.

### 6. Git worktrees for parallel agents on the same repo

Two agents editing one checkout concurrently conflict in ways git cannot
resolve, so each parallel agent gets its own worktree at
`<repo>/.worktrees/<name>` on branch `agent/<name>`, managed by the `wt-agent`
/ `wt-done` wrapper scripts (home-manager, next to `tmux-fzf`).

Rationale for manual wrappers instead of native features:

- **opencode** has no stable worktree CLI flag (only experimental workspaces)
  and has a history of worktree-related session bugs
  (anomalyco/opencode#12726, #16995).
- **claude-code** has native `--worktree` (v2.1.49+), but it places worktrees
  under `.claude/worktrees/`, fragmenting the layout. A uniform manual
  worktree for both agents keeps one layout and one cleanup path.

`.worktrees/` is added to the global git ignore (`~/.config/git/ignore`).

### 7. Agent credentials live only on artemis

`~/.claude/` and `~/.local/share/opencode/auth.json` exist only on artemis.
Client machines never hold tokens. If artemis is down, the fallback is Claude
desktop on the work machine. Concurrent `/login`-style auth mutations from
multiple agents must be avoided (both tools share per-user state).

### 8. No nix binary cache (yet)

"Heavy work" means everything happens over SSH on artemis; the other machines
do not build anything. A binary cache (harmonia / nix-serve) is deferred until
a second NixOS machine actually needs prebuilt paths.

### 9. Always-on desktop with idle power tuning

artemis never suspends (agents must stay reachable). Idle draw is reduced with
a oneshot systemd service setting the AMD EPP to `balance_power` (no-op if
`amd_pstate` is not active). No sleep states.

`powerManagement.powertop.enable` was tried and **rejected**: its
`--auto-tune` enables aggressive USB autosuspend, which made the mouse and
keyboard take seconds to wake after a few idle seconds. CPU EPP provides the
meaningful idle savings without touching input devices.

### 10. Manual Tailscale bootstrap

The node joins the tailnet via a one-time interactive `sudo tailscale up`
instead of a sops-managed auth key: single node, one fewer secret, and the node
key persists in `/var/lib/tailscale` across rebuilds.

### 11. Lingering for user gerry

`users.users.gerry.linger = true` so user-level processes (including any tmux
server with a socket under `/run/user/$UID`) survive full graphical logouts.

### 12. Option-gated NixOS module

All server concerns live in `nixos/modules/server.nix` behind
`awt.server.enable`. Gating is mandatory, not cosmetic: this flake imports
every entry of `self.nixosModules` into every host, so an ungated module would
leak artemis's server config into freya/athena.

## Consequences

Positive:

- Agents survive disconnects, network changes, and client reboots.
- Client machines need nothing but an SSH client; a future Fedora move reuses
  the exact same workflow.
- Credentials are centralized in one well-understood place.

Negative / accepted risks:

- artemis downtime means no agent capability on clients (mitigated by Claude
  desktop as fallback).
- Worktrees require cleanup discipline (`wt-done`); stale worktrees accumulate
  otherwise.
- opencode's worktree handling is version-sensitive; the deployed version
  should be pinned and tested before relying on parallel opencode agents.
