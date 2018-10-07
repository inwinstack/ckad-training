#!/bin/bash
set -e

kubectl create namespace exercise-01

kubectl create -f cm.yaml

kubectl create secret generic database-credentials -n exercise-01 \
--from-literal=root-password=mariapower \
--from-literal=wp-dbname=wordpress \
--from-literal=wp-user=wordpress \
--from-literal=wp-password=wordpresspower \
--from-literal=dr-dbname=drupal \
--from-literal=dr-user=drupal \
--from-literal=dr-password=drupalpower
kubectl create secret generic wp-credentials -n exercise-01 \
--from-literal=user=kubernetes \
--from-literal=password=training
kubectl create secret generic dr-credentials -n exercise-01 \
--from-literal=user=drupal \
--from-literal=password=training

kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml

#kubectl create -f wordpress-deployment.yaml
#kubectl create -f wordpress-svc.yaml

kubectl create -f drupal-deployment.yaml
kubectl create -f drupal-svc.yaml

# Access via browser to:
echo ""
echo "After a few minutes access to:"
echo "Wordpress: http://kubernetes:$(kubectl get svc wordpress -n exercise-01 -o jsonpath="{.spec.ports[0].nodePort}")"
echo "Drupal: http://kubernetes:$(kubectl get svc drupal -n exercise-01 -o jsonpath="{.spec.ports[0].nodePort}")"
