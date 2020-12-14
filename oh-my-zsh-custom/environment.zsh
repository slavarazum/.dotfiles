alias nah="git reset --hard && git clean -df"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias www="cd ~/Development/www"
alias cb="git fetch -p && git branch --remote --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | cut -b 10- | xargs git push --delete origin && git branch --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | xargs git branch -d"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias zshcustom="code ~/.oh-my-zsh/custom"
alias hosts="sudo nano /etc/hosts"

index_base() {
    cd /Users/razum/Development/algolia-docsearch
    docker run -it --env-file=.env -e "CONFIG=$(cat /Users/razum/Development/algolia-docsearch/config.json | jq -r tostring)" algolia/docsearch-scraper
}
