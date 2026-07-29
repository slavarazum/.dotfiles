# .dotfiles

My macOS setup — shell, git, Homebrew packages, and system defaults.
Bootstrapped by a single shell script, orchestrated by TypeScript (Node runs `.ts` natively — no build step).

## Install

On a fresh Mac:

```sh
curl -fsSL https://raw.githubusercontent.com/slavarazum/.dotfiles/main/bootstrap.sh | sh
```

That's it. [`bootstrap.sh`](bootstrap.sh) is shell only because a fresh Mac has no Node yet — it installs Xcode Command Line Tools, Homebrew, and Node, clones this repo to `~/Development/.dotfiles`, then hands off to [`scripts/install.ts`](scripts/install.ts), which does the real work:

1. installs everything in the [`Brewfile`](Brewfile) (existing apps are adopted, not reinstalled)
2. installs oh-my-zsh (without touching the shell or `.zshrc`)
3. symlinks `.zshrc`, `.gitconfig`, `.inputrc`, and `starship.toml` into `$HOME`
   — anything already there is backed up to `~/.dotfiles-backup/<timestamp>/`

If the Xcode CLT dialog appears, finish it and re-run the same command.

Already cloned? Run steps directly:

```sh
pnpm sync:dry    # preview what would happen
pnpm sync        # brew bundle + symlinks
```

## macOS defaults

Optional, curated system preferences (Finder, Dock, keyboard, security, power):

```sh
pnpm macos       # or: node scripts/macos.ts [--dry-run]
```

Prompts for the computer name; some changes need a logout to apply.

## What's inside

| Path | Purpose |
| --- | --- |
| `bootstrap.sh` | Prerequisites only (Xcode CLT, Homebrew, Node, clone) — the `curl` target |
| `scripts/install.ts` | Main installer: brew bundle, oh-my-zsh, symlinks |
| `scripts/macos.ts` | Curated macOS `defaults`, machine name prompt |
| `Brewfile` | CLI tools, apps, fonts — optional extras commented at the bottom |
| `.zshrc` | oh-my-zsh + starship, pnpm, zoxide, fzf, autosuggestions |
| `oh-my-zsh-custom/` | Aliases, functions, PATH, SSH-mode switcher (`ZSH_CUSTOM`) |
| `.gitconfig` | 1Password SSH signing, rebase pull, rerere, zdiff3 conflicts |
| `.config/starship.toml` | Prompt with dirty/clean branch styling |
| `.config/ghostty/config` | Ghostty terminal (Nerd Font + room for more) |
| `.config/gh/config.yml` | GitHub CLI preferences and aliases |
| `.claude/settings.json` | Claude Code preferences |
| `.ssh/config` | 1Password SSH agent + YubiKey mode switcher |
| `.inputrc` | Readline config for bash and other GNU-readline tools |

## Daily helpers

- `use-1p-key` / `use-device-key` / `ssh-mode` — switch git signing between 1Password and YubiKey
- `nah` / `nahlast` — throw away uncommitted work / undo last commit
- `cb` — delete local branches already merged into main
- `nmr` — find and interactively delete `node_modules` directories
- `z <dir>` — jump to frecent directories (zoxide), `Ctrl+R` — fuzzy history (fzf)
- `p` = pnpm, `g` = git, `la` = eza long listing, `ncu` — interactive dependency updates

## Updating

```sh
cd ~/Development/.dotfiles
git pull
pnpm sync        # idempotent — safe to re-run anytime
```
