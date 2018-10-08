#!/bin/bash

## Create namespace
kubectl create -f ns.yaml
## Create secrets for mariadb and wordpress
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
## Create ConfigMap
kubectl create -f cm.yaml
## Create service and deploy of mariadb-master
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
## Create service and deploy of mariadb-slave
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f mariadb-slave-svc.yaml
## Create service and deploy of wordpress
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml


## Scale slaves to 5 replicas:
# kubectl scale deploy mariadb-slave --replicas=5 --namespace=exercise-02
