# Shortcuts

alias _="sudo"
alias g="git"
alias rr="rm -rf"

# Default options

alias rsync="rsync -vh"

# List declared aliases, functions, paths

alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

# Listing (eza when available)

if command -v eza > /dev/null; then
	alias ls="eza"
	alias la="eza -la --git"
	alias lt="eza --tree --level=2"
else
	alias la="ls -la"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# pnpm

alias p="pnpm"
alias ncu="pnpm dlx npm-check-updates --interactive"
alias ncuw="pnpm dlx npm-check-updates --interactive --root --workspaces"

# Network

alias ip="curl -s ipinfo.io | jq -r '.ip'"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Miscellaneous

alias hosts="sudo $EDITOR /etc/hosts"
alias quit="exit"
alias week="date +%V"
alias fkill="ps -e | fzf | awk '{print $1}' | xargs kill"
