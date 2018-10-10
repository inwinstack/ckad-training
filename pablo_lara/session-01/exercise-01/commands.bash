#!/bin/bash

## Create namespace
kubectl create -f ns.yaml
## Create secrets for mariadb and wordpress
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
## Create ConfigMap
kubectl create -f cm.yaml
## Create services for mariadb and wordpress
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml
## Create mariadb-deployment
kubectl create -f mariadb-deployment.yaml
## Create wordpress-deployment stable 4.9.7
kubectl create -f wordpress-deployment.yaml
## Create wordpress-canary-deployment 4.9.8
kubectl create -f wordpress-canary-deployment.yaml
