alias dotfiles="code ~/.dotfiles"

# ZSH
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias zshcustom="code ~/.dotfiles/oh-my-zsh-custom"
alias reload="source ~/.zshrc"

# Git
alias nah="git reset --hard && git clean -df"
alias nahlast="git reset --soft HEAD~ && nah"
alias cb="git fetch -p && git branch --remote --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | cut -b 10- | xargs git push --delete origin && git branch --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | xargs git branch -d"

# System
alias src="cd ~/Development/code"
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias hosts="sudo vim /etc/hosts"
alias rmds="find . -name '.DS_Store' -type f -delete"

cdb() {
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$1\` DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci"
    echo "Database \`$1\` successfully created."
}

init_repo() {
    git init
    git add .
    git commit -am "$([ -z "$1" ] && echo "Initial commit" || echo "$1")"
}
