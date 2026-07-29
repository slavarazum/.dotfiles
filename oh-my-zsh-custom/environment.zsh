alias dotfiles="code $DOTFILES"

# ZSH
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias zshcustom="code $DOTFILES/oh-my-zsh-custom"
alias reload="source ~/.zshrc"

# Git
alias nah="git reset --hard && git clean -df"
alias nahlast="git reset --soft HEAD~ && nah"
# Delete local branches already merged into the default branch
alias cb='git fetch -p && git branch --merged | grep -vE "(^\*|main|master)" | xargs -r git branch -d'

# System
alias src="cd ~/Development/code"
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias rmds="find . -name '.DS_Store' -type f -delete"

init_repo() {
    git init
    git add .
    git commit -am "$([ -z "$1" ] && echo "Initial commit" || echo "$1")"
}
