#!/bin/bash

## Create namespace
kubectl create -f ns.yaml
## Create secrets for mariadb,wordpress
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f ingress-tls.yaml
## Create ConfigMap
kubectl create -f cm.yaml
## Create services for mariadb, wordpress
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml
## Create mariadb-deployment and pvc
kubectl create -f mariadb-pvc.yaml
kubectl create -f mariadb-deployment.yaml

kubectl create -f mysqldump-pvc.yaml
kubectl create -f mysqldump-cronjob.yaml

## Create wordpress-deployment and pvc
kubectl create -f wordpress-pvc.yaml
kubectl create -f wordpress-deployment.yaml


kubectl create -f wordpress-ingress.yaml


kubectl get svc -n exercise-02
