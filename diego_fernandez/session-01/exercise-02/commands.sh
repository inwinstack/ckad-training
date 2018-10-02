#!/usr/bin/env bash

NAMESPACE='exercise-02'
DATABASE_PASSWORD='ultrasecretpassword'
CURRENT_CONTEXT=$(kubectl config current-context)

kubectl create ns $NAMESPACE
kubectl config set-context $CURRENT_CONTEXT --namespace=$NAMESPACE
kubectl create secret generic database-secrets \
--from-literal=root-password=$DATABASE_PASSWORD \
--from-literal=repl-password=$DATABASE_PASSWORD
kubectl apply -f database.cm.yaml
kubectl apply -f mariadb-master.deployment.yaml
kubectl apply -f mariadb-master.svc.yaml
kubectl apply -f mariadb-slave.deployment.yaml
kubectl apply -f mariadb-slave.svc.yaml
kubectl apply -f wordpress.deployment.yaml
kubectl apply -f wordpress.svc.yaml

# Scale slaves to 5 instances
# kubectl scale deployment mariadb-slave --replicas=5
