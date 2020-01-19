function phpcf() {
    /Users/razum/.composer/vendor/bin/php-cs-fixer --config=/Users/razum/Development/coding-standards/laravel_cf.dist --verbose fix $@
}

unit() {
  if [ -f vendor/bin/phpunit ]; then
    vendor/bin/phpunit "$@"
  else
    phpunit "$@"
  fi
}

phpv() {
    valet stop
    brew unlink php@7.1 php@7.2 php@7.3
    brew link --force --overwrite $1
    brew services start $1
    composer global update
	  rm -f ~/.config/valet/valet.sock
    valet install
}

alias php71="phpv php@7.1"
alias php72="phpv php@7.2"
alias php73="phpv php"