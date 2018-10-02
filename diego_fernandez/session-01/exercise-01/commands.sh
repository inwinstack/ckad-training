#!/usr/bin/env bash

NAMESPACE='exercise-01'
DATABASE_PASSWORD='ultrasecretpassword'
CURRENT_CONTEXT=$(kubectl config current-context)

kubectl create ns $NAMESPACE
kubectl config set-context $CURRENT_CONTEXT --namespace=$NAMESPACE
kubectl create secret generic database-secrets \
--from-literal=root-password=$DATABASE_PASSWORD
kubectl apply -f cm.yaml
kubectl apply -f mariadb.deployment.yaml
kubectl apply -f mariadb.svc.yaml
kubectl apply -f wordpress.deployment.yaml
kubectl apply -f wordpress-canary.deployment.yaml
kubectl apply -f wordpress.svc.yaml
