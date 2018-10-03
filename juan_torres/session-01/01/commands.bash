#!/bin/bash

kubectl create -f namespace.yaml

kubectl create secret generic secret-mariadb -n exercise-01 \
	--from-literal=mariadb_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc)) \
	--from-literal=mariadb_root_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc))

kubectl create secret generic secret-wordpress -n exercise-01 \
	--from-literal=wordpress_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc))

kubectl create -f cm.yaml

kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml

kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml
sleep 10
kubectl create -f wordpress-canary-deployment.yaml
