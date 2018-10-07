#!/bin/bash
set -e

kubectl create namespace exercise-01

kubectl create -f cm.yaml

kubectl create secret generic database-credentials -n exercise-01 \
--from-literal=root-password=mariapower \
--from-literal=wp-dbname=wordpress \
--from-literal=wp-user=wordpress \
--from-literal=wp-password=wordpresspower
kubectl create secret generic wp-credentials -n exercise-01 \
--from-literal=user=kubernetes \
--from-literal=password=training

kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml

kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml

# Access via browser to:
echo ""
echo "After a few minutes access to:"
echo "http://kubernetes:$(kubectl get svc wordpress -n exercise-01 -o jsonpath="{.spec.ports[0].nodePort}")"
