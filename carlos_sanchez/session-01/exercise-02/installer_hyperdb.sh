#!/bin/bash

set -e

export NS="exercise-02"
export POD=$(kubectl -n ${NS} get pods -l app=wordpress -o jsonpath="{.items[0].metadata.name}")
export SNAME="master-slave:3306"
export BASEDIR="/opt/bitnami/wordpress/"
export CONFILE="/opt/bitnami/wordpress/wp-config.php"
export DBFILE="/opt/bitnami/wordpress/db-config.php"
export WPDIR="/opt/bitnami/wordpress/wp-content/"

# DB_SLAVE added
sed -i '0,/DB_HOST/! s/DB_HOST/DB_SLAVE/' hyperdb/db-config.php

# Copy files
kubectl cp ./hyperdb/db-config.php ${NS}/${POD}:${DBFILE}

# Add value to DB_SLAVE
kubectl -n ${NS} exec ${POD} -- /bin/sed -i "/define('DB_HOST'/a define('DB_SLAVE', '${SNAME}');" ${CONFILE}

#Deploy db.php to the /wp-content/ directory.
kubectl cp ./hyperdb/db.php ${NS}/${POD}:${WPDIR}

# Set privileges
kubectl -n ${NS} exec ${POD} -- chown -R bitnami:daemon ${BASEDIR}

echo "HyperDB READY!"
