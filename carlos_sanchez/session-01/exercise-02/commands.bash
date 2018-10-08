#!/bin/bash

echo "Creating namespace exercise-02 ..."
kubectl create -f namespace.yaml

echo "Creating a secret value for the mariadb password ..."
kubectl -n exercise-02 create secret generic exercise-02-secrets \
    --from-literal=mariadb_root_password=IAMROOT \
    --from-literal=wp_database=db_wordpress \
    --from-literal=mariadb_wp_user=wordpress_user \
    --from-literal=mariadb_wp_password=IAMNORMAL \
    --from-literal=replication_user=diplo \
    --from-literal=replication_password=IAMDIPLO \
    --from-literal=mariadb_host=mariadb-master \
    --from-literal=wp_user=charlie \
    --from-literal=wp_password=IAMCHARLIE

echo "Creating a configmap to store the values ... "
kubectl create -f configmap.yaml

echo "Creating the deployments for mariadb(master/slave) and wordpress ..."
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f wordpress-deployment.yaml

echo "Creating the necessary services to expose the application ..."
kubectl create -f mariadb-master-svc.yaml
kubectl create -f mariadb-slave-svc.yaml
kubectl create -f wordpress-svc.yaml

echo "The wordpress will be available in about 5 minutes."
