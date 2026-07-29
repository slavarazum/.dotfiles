# Path to the dotfiles repo
export DOTFILES="$HOME/Development/.dotfiles"

# Prefer Homebrew binaries over system ones
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.local/bin:$PATH"

# --- oh-my-zsh ---------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

# Prompt is rendered by starship (see below), so no oh-my-zsh theme
ZSH_THEME=""

ZSH_CUSTOM="$DOTFILES/oh-my-zsh-custom"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# --- Node / pnpm -------------------------------------------------------------

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Shell niceties ----------------------------------------------------------

# Autosuggestions + syntax highlighting (installed via Brewfile)
[ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Smarter cd: `z <dir>` jumps to the most-used matching directory
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"

# Fuzzy Ctrl+R history search and Ctrl+T file picker
command -v fzf > /dev/null && source <(fzf --zsh)

# Prompt
command -v starship > /dev/null && eval "$(starship init zsh)"
