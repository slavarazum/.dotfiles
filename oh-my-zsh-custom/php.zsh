unit() {
  if [ -f vendor/bin/phpunit ]; then
    vendor/bin/phpunit "$@"
  else
    phpunit "$@"
  fi
}

unitf() {
  if [ -f vendor/bin/phpunit ]; then
    vendor/bin/phpunit --filter="$@"
  else
    phpunit --filter="$@"
  fi
}

unit:fails() {
  if [ -f vendor/bin/phpunit ]; then
    vendor/bin/phpunit --order-by=defects --stop-on-defect
  else
    phpunit --order-by=defects --stop-on-defect
  fi
}
