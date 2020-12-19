# Helper functions for Laravel Valet
# To get more information visit https://laravel.com/docs/5.6/valet

function valet() {
    services=(
        mysql
        redis
    )

    if [ "$1" = "start" ] || [ "$1" = "stop" ] || [ "$1" = "restart" ]; then
        /usr/local/bin/valet $1
        for service in $services; do
            brew services $1 $service
        done
    else
        /usr/local/bin/valet $@
    fi
}
