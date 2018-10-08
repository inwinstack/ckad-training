FROM bitnami/wordpress:latest
#COPY resources/init.sh /
ADD http://downloads.wordpress.org/plugin/hyperdb.zip /bitnami/
RUN apt-get update && apt-get install unzip -f; \
  unzip /bitnami/hyperdb.zip -d /bitnami/; \
  sed -i '0,/DB_HOST/! s/DB_HOST/DB_SLAVE/' /bitnami/hyperdb/db-config.php; \
  cp /bitnami/hyperdb/db-config.php /opt/bitnami/wordpress/db-config.php; \
  sed -i "/define('DB_HOST'/a define('DB_SLAVE', 'master-slave:3306');" /opt/bitnami/wordpress/wp-config.php; \
  cp /bitnami/hyperdb/db.php /opt/bitnami/wordpress/wp-content/; \
  chmod a-w /opt/bitnami/wordpress/wp-content/db.php; \
  chown -R bitnami:daemon /opt/bitnami/wordpress/

