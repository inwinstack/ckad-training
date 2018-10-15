#!/bin/bash
set -e

curl -LO http://downloads.wordpress.org/plugin/hyperdb.zip
apt-get update -q
apt-get install -y zip
unzip hyperdb.zip
sed -i '0,/DB_HOST/! s/DB_HOST/DB_SLAVE/' hyperdb/db-config.php
cp hyperdb/db-config.php /opt/bitnami/wordpress/db-config.php
sed -i "/define('DB_HOST'/a define('DB_SLAVE', 'master-slave:3306');" /opt/bitnami/wordpress/wp-config.php
cp hyperdb/db.php /opt/bitnami/wordpress/wp-content/
chmod a-w /opt/bitnami/wordpress/wp-content/db.php
chown -R bitnami:daemon /opt/bitnami/wordpress/

echo "HyperDB installed!"
