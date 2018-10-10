#!/bin/bash

## Create namespace
kubectl create namespace exercise-02

## Create configmap & secrets
echo "==> Creating namespace, configmaps and secrets..."
kubectl create -f cm.yaml
kubectl create configmap hyperdb-script --from-file=install-hyperdb.sh -n exercise-02
kubectl create secret generic wordpress-secret -n exercise-02 \
--from-literal=user=kubernetes \
--from-literal=password=training
kubectl create secret generic mariadb-secret -n exercise-02 \
--from-literal=replication-user=replication_user \
--from-literal=replication-password=replication_password \
--from-literal=root-user=root \
--from-literal=root-password=root_password \
--from-literal=database-name=bitnami_wordrpess \
--from-literal=database-user=bn_wordpress \
--from-literal=database-password=database_password

## Create backend deployments and services
echo "==> Creating MariaDB backend..."
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
while [ "$(kubectl get deploy mariadb-master -n exercise-02 -o jsonpath='{.status.readyReplicas}')" != "1" ]; do sleep 5; done
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f mariadb-slave-svc.yaml
## Create frontend deployment and service
echo "==> Creating WP frontend..."
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml


## Wait for everything to be setup
echo "==> Waiting for setup to be ready..."
while [ "$(kubectl get deploy wordpress -n exercise-02 -o jsonpath='{.status.readyReplicas}')" != "1" ]; do sleep 5; done
echo "==> Scaling MariaDB slave pods..."
kubectl scale deploy mariadb-slave --replicas 5 -n exercise-02

## HyperDB installation
echo "==> Configuring HyperDB..."
kubectl exec $(kubectl get pod -lapp=wordpress,tier=frontend -n exercise-02 -o jsonpath='{.items[0].metadata.name}') -n exercise-02 -- /tmp/hyperdb-script/install-hyperdb.sh

echo ""
echo "============================="
echo "==> WP Credentials"
echo "==>   User: $(kubectl get secret wordpress-secret -n exercise-02 -o jsonpath='{.data.user}' | base64 --decode)"
echo "==>   Password: $(kubectl get secret wordpress-secret -n exercise-02 -o jsonpath='{.data.password}' | base64 --decode)"
echo "============================="
