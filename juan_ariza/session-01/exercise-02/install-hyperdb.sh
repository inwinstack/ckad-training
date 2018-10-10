#!/bin/bash -e

sed -i '0,/DB_HOST/! s/DB_HOST/DB_SLAVE/' /tmp/hyperdb/db-config.php
sed -i "/define('DB_HOST'/a define('DB_SLAVE', 'master-slave:3306');" /opt/bitnami/wordpress/wp-config.php

cp /tmp/hyperdb/db-config.php /opt/bitnami/wordpress/db-config.php
cp /tmp/hyperdb/db.php /opt/bitnami/wordpress/wp-content/
chmod a-w /opt/bitnami/wordpress/wp-content/db.php
chown -R bitnami:daemon /opt/bitnami/wordpress/

echo -n "==> HyperDB configured successfully on WP!!"
