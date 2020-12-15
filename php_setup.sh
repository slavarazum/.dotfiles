# Install PHP extensions with PECL
pecl install imagick
pecl install redis
pecl install xdebug

# Config auth tokens
composer global config github-oauth.github.com $GITHUB_TOKEN
composer global config http-basic.nova.laravel.com $NOVA_EMAIL $NOVA_TOKEN

# Install global Composer packages
composer global require laravel/valet
composer global require laravel/installer
composer global require beyondcode/expose
composer global require laravel/vapor-cli

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install