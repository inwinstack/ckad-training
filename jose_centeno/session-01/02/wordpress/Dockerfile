FROM bitnami/wordpress:latest
#COPY resources/init.sh /
COPY resources/db-config.php /bitnami/php/conf/
COPY resources/wp-config.php /bitnami/wordpress/
#Document says to put on wp-content but I think it should be on plugins
COPY resources/db.php /bitnami/wordpress/wp-content/
COPY resources/db.php /bitnami/wordpress/wp-content/plugins/
#ENTRYPOINT [ "/init.sh" ]
