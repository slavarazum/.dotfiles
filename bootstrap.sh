#!/bin/sh
#
# Bootstrap a fresh Mac:
#   curl -fsSL https://raw.githubusercontent.com/slavarazum/.dotfiles/main/bootstrap.sh | sh
#
# Shell, because a fresh Mac has no Node to run TypeScript with. Installs only
# the prerequisites (Xcode CLT, Homebrew, Node) and clones the repo, then hands
# off to scripts/install.ts — which does the actual setup.

set -e

DOTFILES="$HOME/Development/.dotfiles"
REPO="https://github.com/slavarazum/.dotfiles.git"

info() { printf '\033[34m▸ %s\033[0m\n' "$1"; }

# Xcode Command Line Tools (git, compilers)
if ! xcode-select -p > /dev/null 2>&1; then
  info "Installing Xcode Command Line Tools — confirm the dialog, then re-run this script when it finishes"
  xcode-select --install
  exit 0
fi

# Homebrew
if ! command -v brew > /dev/null 2>&1; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make brew available in this shell (Apple Silicon / Intel)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Node — needed to run the TypeScript installer
if ! command -v node > /dev/null 2>&1; then
  info "Installing Node"
  brew install node
fi

# Clone (or reuse) the repo
if [ ! -d "$DOTFILES" ]; then
  info "Cloning dotfiles to $DOTFILES"
  mkdir -p "$HOME/Development"
  git clone "$REPO" "$DOTFILES"
else
  info "Using existing repo at $DOTFILES"
fi

cd "$DOTFILES"
exec node scripts/install.ts
