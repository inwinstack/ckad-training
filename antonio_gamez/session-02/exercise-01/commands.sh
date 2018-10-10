############################ # ############################
## Bitnami K8S training
## session02/exercise01
#
## Author: Antonio Gamez-Diaz
## Contact: antoniogamez@us.es
#
# File: init script
# Purpose: defines the steps to set up the scenario
############################ # ############################

#!/bin/bash

# Prerequisites:
#   - Helm. See https://helm.sh
#   - A fully working nginx-ingress-controller is suppossed to be installed in the cluster.
#     If it is not, please follow this guide: https://kubernetes.github.io/ingress-nginx/deploy/
#     For Docker for Win/Mac, it is enough to enter these two commands:
#        > kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
#        > kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
#   - An installation of cert-manager (former kube-lego)
#     If it is not installed, please type:
#        > helm install --name cert-manager --namespace kube-system stable/cert-manager


## Create namespace 's02-exercise-01'
kubectl create ns s02-exercise-01

## Use it as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=s02-exercise-01
# Check it by `kubectl config view --minify`

# Delete previously created pvc
kubectl delete pvc --all 

## Create all resources (in order: db master, frontend)
kubectl create -f ./resources/cert-manager/production
kubectl create -f ./resources/netpol
kubectl create -f ./resources/mariadb-master
kubectl create -f ./resources/mariadb-slave
kubectl create -f ./resources/wordpress
kubectl create -f ./resources/drupal
kubectl create -f ./resources/drupal
kubectl create -f ./resources/ingress


# Remove everything created
# kubectl delete ns s02-exercise-01
## or kubectl delete -f ./resources -R