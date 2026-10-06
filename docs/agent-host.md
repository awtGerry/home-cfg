# Agent host runbook: artemis

How to set up and use artemis as the centralized machine that runs AI agents
(opencode, claude-code) in persistent tmux sessions, reachable over SSH from
other machines. The rationale for each decision lives in
[ADR 0001](./adr/0001-centralized-agent-host.md).

## One-time setup

### 1. Tailscale on the Windows 11 host (work machine)

1. Install Tailscale from <https://tailscale.com/download/windows> and log in.
2. Do **not** install Tailscale inside WSL — WSL2 reaches the tailnet through
   the Windows host's network stack.
3. If MagicDNS names (`artemis`) don't resolve from WSL or connections feel
   broken, edit `%UserProfile%\.wslconfig` on Windows:

   ```ini
   [wsl2]
   networkingMode=mirrored
   dnsTunneling=true
   ```

   then run `wsl --shutdown` and reopen WSL. Only do this if you hit problems;
   the default NAT mode usually works.

### 2. SSH key in WSL

The existing WSL key is for GitHub; generate a dedicated one for artemis:

```sh
ssh-keygen -t ed25519 -C "gerry@work-wsl-artemis" -f ~/.ssh/id_ed25519_artemis
cat ~/.ssh/id_ed25519_artemis.pub
```

Add the printed public key to `awt.server.authorizedKeys` in
`nixos/configurations/artemis.nix`, then rebuild on artemis:

```sh
sudo nixos-rebuild switch --flake .#artemis
```

> Note: password authentication is disabled. Until the public key is added and
> the rebuild finishes, remote login is impossible — this is fail-closed on
> purpose.

### 3. Tailscale on artemis

After the rebuild (the module enables `tailscaled`):

```sh
sudo tailscale up
tailscale status    # artemis should appear with a 100.x.y.z address
```

The login is a one-time browser flow; the node key persists in
`/var/lib/tailscale` across reboots and rebuilds.

### 4. SSH client config in WSL

`~/.ssh/config`:

```sshconfig
Host artemis
    HostName artemis          # MagicDNS name; or use the 100.x address
    User gerry
    IdentityFile ~/.ssh/id_ed25519_artemis
    ServerAliveInterval 30
```

Test: `ssh artemis`.

### 5. iOS (iPad / iPhone) with Blink Shell

Prerequisite: steps 1–3 above are done for artemis itself (`awt.server.enable =
true`, tailscaled up). The iOS device is just another thin client.

#### 5.1 Tailscale on iOS

1. Install Tailscale from the App Store and log in with the same account as
   artemis.
2. Turn the VPN toggle on (iOS installs a VPN profile the first time).
3. In the app, enable **Use Tailscale DNS** (MagicDNS) so the name `artemis`
   resolves. Without it you must use the `100.x.y.z` address.
4. Check artemis appears in the machine list before touching Blink.

#### 5.2 Key in Blink

Blink keeps its own key store; there is no `~/.ssh` to copy a key into.

1. Install **Blink Shell** (App Store, paid).
2. `Settings → Keys → +  → New Key`
   - Type: **ED25519** (matches the other keys in the flake)
   - Name: `artemis-ios`
   - Optional: a passphrase, or a **Secure Enclave** key instead — that one is
     an ECDSA key, which sshd accepts just the same; paste whatever the public
     key field shows.
3. Tap the key → **Copy Public Key**.

#### 5.3 Authorize the key on artemis

Chicken-and-egg: the iPad cannot SSH in to add its own key. Get the public key
onto artemis some other way (Notes, a message to yourself, typing it out), or
edit the flake from a machine that is already authorized.

In `nixos/configurations/artemis.nix`:

```nix
awt.server = {
  enable = true;
  authorizedKeys = [
    # ...existing keys...
    "ssh-ed25519 AAAA... gerry@ipad-blink"
  ];
};
```

Then on artemis:

```sh
sudo nixos-rebuild switch --flake .#artemis
```

> Same fail-closed rule as step 2: until the rebuild finishes, Blink will only
> ever get `Permission denied (publickey)`.

#### 5.4 Host entry in Blink

`Settings → Hosts → +`:

| Field | Value |
|---|---|
| Host | `artemis` |
| HostName | `artemis` (MagicDNS) or `100.x.y.z` |
| User | `gerry` |
| Port | `22` |
| Key | `artemis-ios` |

From the Blink prompt: `ssh artemis`.

#### 5.5 Keyboard (the part that decides whether this is usable)

- The tmux prefix in this config is **`Ctrl+Space`**, and iOS grabs
  `Ctrl+Space` for the hardware-keyboard input-source switch. Either remove the
  extra layouts in `iOS Settings → General → Keyboard → Hardware Keyboard`, or
  give tmux a second prefix in
  `home/modules/profiles/base/default.nix` (`programs.tmux.extraConfig`):

  ```nix
  set -g prefix2 C-a
  ```

  `prefix2` is additive — `Ctrl+Space` keeps working on the machines where it
  never collided.
- `Blink Settings → Keyboard`: map **Caps Lock → Ctrl** for a hardware
  keyboard. Without a hardware keyboard, the smart-keys bar above the on-screen
  keyboard carries `Ctrl` / `Alt` / `Esc` / arrows — enough for tmux and helix,
  but a real keyboard is the difference between "works" and "pleasant".
- `Settings → Appearance`: Fira Code, size to taste. If starship's glyphs come
  out as boxes, add a Nerd Font there (Blink takes a font by URL).

#### 5.6 Optional: mosh instead of ssh

[ADR 0001 §1](./adr/0001-centralized-agent-host.md) rejected mosh for the WSL
client (UDP is often blocked on corporate networks, and tmux already covers
disconnects). On iOS the trade is different: every Wi-Fi↔LTE handover kills an
SSH connection, and mosh is Blink's native mode. If the reconnect dance gets
old, in `nixos/modules/server.nix` inside `config = lib.mkIf cfg.enable { ... }`:

```nix
programs.mosh = {
  enable = true;
  openFirewall = false;   # tailscale0 is already a trusted interface
};
```

`openFirewall = true` (the default) would open UDP 60000–61000 on every
interface; `false` keeps mosh tailnet-only, which is all the iPad needs. Then
in Blink use `mosh artemis` instead of `ssh artemis`. If you keep it, amend
ADR 0001 §1 — the decision changed.

## Daily workflow

From the work machine (WSL):

```sh
ssh artemis
ff                     # tmux-fzf: pick or create the repo's session
```

Inside the repo session:

- Run the agent in a window as usual (`opencode`, `claude`).
- Detach with `Ctrl+Space d` (or just close the terminal / lose the connection) —
  the agents keep running on artemis.
- Reconnect later with `ssh artemis` then `ta` / `ff` to reattach.

### From iOS (Blink)

```sh
ssh artemis
ff                     # tmux-fzf: pick or create the repo's session
ta                     # or straight to the last session
```

- Backgrounding Blink (app switcher, lock screen) drops the connection after a
  few seconds — iOS suspends the app. That is fine: tmux on artemis is the
  session, Blink is only a window onto it. Reopen and `ta`.
- tmux sizes a session to the **smallest** attached client, so a forgotten
  attach on the desktop shrinks the iPad view (and vice versa). `tmux a -d`
  detaches the other clients while attaching.
- Same rule as everywhere else: don't run agent `/login` flows from two clients
  at once.

### Parallel agents on the same repo

From inside the repo session (or any shell inside the repo):

```sh
wt-agent fix-auth opencode     # worktree .worktrees/fix-auth, branch agent/fix-auth,
                               # new tmux window running opencode
wt-agent fix-auth claude       # second agent on its own worktree
```

When the agent's work is merged or discarded:

```sh
wt-done fix-auth               # closes the window, removes the worktree and branch
```

Agents on worktrees work on branch `agent/<name>`; review, merge or cherry-pick
into your main branch as with any other branch.

### Rules of thumb

- `git pull` before starting work (already habitual).
- Never run `opencode auth login` / `/login` in claude from two agents at once;
  both tools share per-user auth state in `$HOME`.
- A repo with a running agent session is hands-off locally until it's done.

## Memory protection

Several agents linking at once (`ld` at 1GB+ each) used to exhaust the 16GB
and freeze the machine until someone power-cycled it. Three layers now
prevent that:

1. **Agent memory cap (home-manager, `agents.memoryCap`).** The tmux server is
   socket-activated inside `agents.slice` (`MemoryMax=10G`), and tmux puts
   every pane in the server's slice. All agents together can't exceed the cap;
   when they hit it, the kernel kills the biggest process *inside the slice*
   (usually an `ld`, the agent sees exit 137) and the desktop, browser and sshd
   never notice. A drop-in sets `OOMPolicy=continue` on pane scopes so that
   kill doesn't take the whole pane (and its agent) down with it. There is no
   `MemoryHigh` on purpose: above it the kernel throttles the whole slice and
   a runaway `ld` crawls for minutes instead of dying.
2. **earlyoom (NixOS, `awt.server`).** System-wide safety net for what runs
   outside the slice (docker builds, `nix build`, Steam). Kills at ~10% free
   RAM + swap, preferring linkers/compilers and avoiding the session.
3. **Magic SysRq.** If it still freezes: `Alt+PrtSc+F` kills the biggest
   process immediately. `Alt+PrtSc` + `R E I S U B` (slowly) is a safe reboot
   — use it instead of the power button.

### Activating the cap (one time)

After `sudo nixos-rebuild switch --flake .#artemis` and
`home-manager switch --flake .#gerry@artemis`, the tmux socket unit refuses to
start while a tmux server is already running (taking its socket would leave
those sessions running but unreachable). When the agents are idle:

```sh
tmux kill-server
rm -f "$XDG_RUNTIME_DIR/tmux-$(id -u)/default"
systemctl --user start tmux.socket
```

Or just reboot. From then on nothing changes in the workflow (`ff`, `ta`,
`wt-agent`); home-manager switches keep the running server (`keep-old`).

Check it: `systemctl --user status agents.slice` should list `tmux.service`
and the `tmux-spawn-*.scope` panes.

## Troubleshooting

| Symptom | Check |
|---|---|
| `ssh artemis` times out | `tailscale status` on both machines; is artemis powered on? Try the LAN IP to isolate Tailscale. |
| Permission denied (publickey) | Is the WSL pubkey in `awt.server.authorizedKeys`? Did the rebuild finish? `ssh -v artemis` for detail. |
| MagicDNS name doesn't resolve in WSL | Use the `100.x.y.z` address; if persistent, apply the `.wslconfig` change from step 1. |
| tmux session gone after reboot | Expected — tmux survives disconnects and logouts, not reboots. |
| A build died with `Killed` / exit 137 | The agents hit the 10G cap (or earlyoom fired). `journalctl --user -g 'OOM killer'` (look for `agents.slice`) / `journalctl -u earlyoom`. Retry with fewer parallel jobs. |
| Panes aren't in `agents.slice` | The server predates the socket unit: `systemctl --user status tmux.socket` says the condition failed. Follow "Activating the cap". |
| Machine frozen anyway | `Alt+PrtSc+F`, wait a few seconds; if still frozen, `Alt+PrtSc` + `R E I S U B`. |
| Mouse/keyboard lag after a few idle seconds | USB autosuspend from powertop. `for f in /sys/bus/usb/devices/*/power/control; do echo on \| sudo tee $f; done` for immediate relief; powertop is no longer in the config. |
| Agents idle-slow or machine hot | `cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference` should say `balance_power`; `systemctl status amd-epp-balance-power` for the unit that sets it. |
| Stale worktrees | `git worktree list`; remove leftovers with `git worktree remove <path>` and `git branch -D agent/<name>`. |
| Blink can't resolve `artemis` | Enable **Use Tailscale DNS** in the Tailscale iOS app, or put the `100.x.y.z` address in the host entry. |
| Blink drops the connection whenever you switch apps | Expected — iOS suspends the app. Reconnect and `ta`; the agents never stopped. |
| `Ctrl+Space` does nothing in Blink | iOS is eating it for the input-source switch. Drop the extra hardware-keyboard layouts, or add `set -g prefix2 C-a`. |
| tmux window is tiny / letterboxed on the iPad | Another client is attached with a smaller size. `tmux a -d`. |
| Copy-mode `y` doesn't reach the iOS clipboard | The binding pipes to `xclip` on artemis. Use Blink's own selection (press and hold → Copy). |
