#!/bin/bash

## Create namespace
kubectl create -f ns.yaml
## Create secrets for mariadb,wordpress
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f ingress-tls.yaml
## Create ConfigMap
kubectl create -f cm.yaml
# Create NetworkPolicy
kubectl create -f networkpolicies.yaml
## Create services for mariadb, wordpress and drupal
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f drupal-svc.yaml
## Create mariadb-statefulset and pvc
kubectl create -f mariadb-statefulset.yaml
kubectl create -f mariadb-pvc.yaml
## Create wordpress-statefulset and pvc
kubectl create -f wordpress-statefulset.yaml
kubectl create -f wordpress-pvc.yaml

kubectl create -f drupal-statefulset.yaml
kubectl create -f drupal-pvc.yaml

kubectl create -f wordpress-ingress.yaml
kubectl create -f drupal-ingress-admin.yaml
kubectl create -f drupal-ingress.yaml


kubectl get svc -n exercise-01
