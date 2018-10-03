#!/bin/bash

if [[ ! -z "$MARIADB_HOST_SLAVE" ]]
then
  echo "MARIADB_HOST_SLAVE is set"
  cat >> /bitnami/wordpress/wp-config.php <<EOF
define('DB_SLAVE_1', '$MARIADB_HOST_SLAVE');
EOF
else
  echo "MARIADB_HOST_SLAVE is not set"
fi

./app-entrypoint.sh nami start --foreground apache
