alias nah="git reset --hard && git clean -df"
alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias www="cd ~/Development/www"
alias cb="git fetch -p && git branch --remote --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | cut -b 10- | xargs git push --delete origin && git branch --merged origin/develop | grep --invert-match 'develop' | grep --invert-match 'master' | grep --invert-match HEAD | xargs git branch -d"
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

function docker-up() {
    cd /Users/razum/Development/Laradock
    docker-compose up -d nginx mysql redis mailhog laravel-echo-server
}

function docker-stop() {
    cd /Users/razum/Development/Laradock
    docker-compose stop
}

commit_date() {
    GIT_COMMITTER_DATE="$@" git commit --amend --no-edit --date "$@"
}

index_base() {
    cd /Users/razum/Development/algolia-docsearch
    docker run -it --env-file=.env -e "CONFIG=$(cat /Users/razum/Development/algolia-docsearch/config.json | jq -r tostring)" algolia/docsearch-scraper
}
