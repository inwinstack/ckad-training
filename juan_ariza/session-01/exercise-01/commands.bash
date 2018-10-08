#!/bin/bash

## Create namespace
kubectl create namespace exercise-01

## Create configmap & secrets
echo "==> Creating namespace, configmaps and secrets..."
kubectl create -f cm.yaml
kubectl create secret generic wordpress-secret -n exercise-01 \
--from-literal=user=kubernetes \
--from-literal=password=training
kubectl create secret generic mariadb-secret -n exercise-01 \
--from-literal=root-password=root_password \
--from-literal=database-name=bitnami_wordrpess \
--from-literal=database-user=bn_wordpress \
--from-literal=database-password=database_password

## Create backend deployment and service
echo "==> Creating MariaDB backend..."
kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml
## Create frontend deployments and service
echo "==> Creating WP frontend..."
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml
kubectl create -f wordpress-svc.yaml

echo ""
echo "============================="
echo "==> WP Credentials"
echo "==>   User: $(kubectl get secret wordpress-secret -n exercise-01 -o jsonpath='{.data.user}' | base64 --decode)"
echo "==>   Password: $(kubectl get secret wordpress-secret -n exercise-01 -o jsonpath='{.data.password}' | base64 --decode)"
echo "============================="
