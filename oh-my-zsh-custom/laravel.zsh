alias art="php artisan"

artisan() {
  if [ -f bin/artisan ]; then
    php bin/artisan "$@"
  else
    php artisan "$@"
  fi
}

alias serve='artisan serve'
alias t='artisan tinker'