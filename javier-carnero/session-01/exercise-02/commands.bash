#!/bin/bash
set -e

kubectl create namespace exercise-02

kubectl create -f cm.yaml

kubectl create secret generic database-credentials -n exercise-02 \
--from-literal=root-password=mariapower \
--from-literal=repl-user=mariarepl \
--from-literal=repl-password=mariareplpower \
--from-literal=wp-dbname=wordpress \
--from-literal=wp-user=wordpress \
--from-literal=wp-password=wordpresspower
kubectl create secret generic wp-credentials -n exercise-02 \
--from-literal=user=kubernetes \
--from-literal=password=training

kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f mariadb-slave-svc.yaml

kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml

# Access via browser to:
echo ""
echo "After a few minutes access to:"
echo "http://kubernetes:$(kubectl get svc wordpress -n exercise-02 -o jsonpath="{.spec.ports[0].nodePort}")"
