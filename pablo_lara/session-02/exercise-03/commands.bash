#!/bin/bash

## Create namespace
kubectl create -f ns.yaml
## Create secrets for mariadb,wordpress
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f ingress-tls.yaml
## Create ConfigMap
kubectl create -f mariadb-config.yaml
kubectl create -f cm.yaml
## Create services for mariadb, wordpress
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml
## Create mariadb-statefulset and pvc
kubectl create -f mariadb-statefulset.yaml
kubectl create -f mariadb-pvc.yaml
## Create wordpress-deployment and pvc
kubectl create -f wordpress-pvc.yaml
kubectl create -f wp-pvc-bk.yaml
#kubectl create -f wordpress-pvc-data.yaml
kubectl create -f wordpress-deployment.yaml


kubectl create -f wordpress-ingress.yaml

kubectl get svc -n exercise-03
