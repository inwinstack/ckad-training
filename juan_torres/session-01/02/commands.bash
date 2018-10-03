#!/bin/bash

kubectl create -f namespace.yaml

kubectl create secret generic secret-mariadb -n exercise-02 \
	--from-literal=mariadb_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc)) \
	--from-literal=mariadb_replication_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc)) \
	--from-literal=mariadb_root_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc))

kubectl create secret generic secret-wordpress -n exercise-02 \
	--from-literal=wordpress_password=$(openssl rand -hex $(echo $RANDOM %2 +8 | bc))

kubectl create -f cm.yaml

kubectl create -f mariadb-master-svc.yaml
kubectl create -f mariadb-slave-svc.yaml
kubectl create -f wordpress-svc.yaml

kubectl create -f mariadb-master-deployment.yaml
sleep 5
kubectl create -f mariadb-slave-deployment.yaml
sleep 5
kubectl create -f wordpress-deployment.yaml

sleep 10
kubectl scale --replicas=5 deployment/mariadb-slave -n exercise-02

kubectl get deploy mariadb-slave -n exercise-02 -o json | jq '.spec.strategy.rollingUpdate.maxUnavailable = "40%"' > temp.yaml  \
	&& kubectl replace -f temp.yaml \
	&& rm -f temp.yaml
	