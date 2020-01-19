# Install PHP extensions with PECL
# TODO: export configs to own files
pecl install imagick
pecl install redis
pecl install xdebug

# Config auth tokens
composer global config github-oauth.github.com d751b3183b274825bcd44617b4d1209c9f800ea0
composer global config http-basic.nova.laravel.com vyacheslav.razum@gmail.com 545b6J95KZjdVbdCU9qUAmeJv97VscqYnRDkriig

# Install global Composer packages
composer global require laravel/valet
composer global require phpmd/phpmd:@stable
composer global require friendsofphp/php-cs-fixer
composer global require laravel/installer
composer global require hirak/prestissimo

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install