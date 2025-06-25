package:test:stable() {
  composer require illuminate/contracts=^"$@" --no-interaction --no-update
  composer update --prefer-stable --prefer-dist --no-interaction
  composer test:unit
}

package:test:lowest() {
  composer require illuminate/contracts=^"$@" --no-interaction --no-update
  composer update --prefer-lowest --prefer-dist --no-interaction
  composer test:unit
}

unit() {
  if [ -f ./artisan ]; then
    php artisan test "$@"
  fi
}

unitf() {
  if [ -f ./artisan ]; then
    php artisan test --filter="$@"
  fi
}

unit:fails() {
  if [ -f ./artisan ]; then
    php artisan test --order-by=defects --stop-on-defect
  fi
}
