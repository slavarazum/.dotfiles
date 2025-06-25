alias a="php artisan"

artisan() {
  if [ -f bin/artisan ]; then
    php bin/artisan "$@"
  else
    php artisan "$@"
  fi
}

alias serve='artisan serve'
alias t='artisan tinker'
alias dusk='artisan dusk'
alias dusks='dusk --stop-on-failure'
alias routes='artisan route:list | grep '
alias sail='vendor/bin/sail'
alias mfs='artisan migrate:fresh --seed'

duskf() {
  if [ -f bin/artisan ]; then
    php bin/artisan dusk --stop-on-failure --filter=$@
  else
    php artisan dusk --stop-on-failure --filter=$@
  fi
}
