# Shortcuts

alias _="sudo"
alias g="git"
alias rr="rm -rf"
alias mux="tmuxinator"

# Default options

alias rsync="rsync -vh"
alias json="json -c"
alias psgrep="psgrep -i"

# Global aliases

# List declared aliases, functions, paths

alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
alias paths='echo -e ${PATH//:/\\n}'

alias la='ls -la'

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"                  # Go to previous dir with -
alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# p/npm

alias b="bun"
alias p="pnpm"
alias ncu="npm-check-updates --interactive"
alias ncuw="npm-check-updates --interactive --root --workspaces"

# Network

alias ip="curl -s ipinfo.io | jq -r '.ip'"
alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Miscellaneous

alias hosts="sudo $EDITOR /etc/hosts"
alias quit="exit"
alias week="date +%V"
alias grip="grip --browser --pass=$GITHUB_TOKEN"
alias fkill="ps -e | fzf | awk '{print $1}' | xargs kill"
alias formatmd="remark --use remark-preset-webpro"
