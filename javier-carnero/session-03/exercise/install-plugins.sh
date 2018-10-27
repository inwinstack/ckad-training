while true; do
    if curl http://localhost/wp-login.php; then
        echo
        echo 'Installing plugins...';
        curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
        chmod +x wp-cli.phar;
        mv wp-cli.phar /usr/local/bin/wp;
        ln -s /opt/bitnami/php/bin/php /usr/bin/php
        sed -i "/remove x-pingback HTTP header/a if ( !defined( 'WP_CLI' ) ) {" /opt/bitnami/wordpress/wp-config.php
        echo "}" >> /opt/bitnami/wordpress/wp-config.php
        sudo -u bitnami -i -- wp plugin install --path=/opt/bitnami/wordpress "$@";
        exit 0;
    else
        echo
        echo 'Wordpress not ready...';
    fi
    sleep 15;
done;