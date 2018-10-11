############################ # ############################
## Bitnami K8S training
## session02/exercise03-p01
#
## Author: Antonio Gamez-Diaz
## Contact: antoniogamez@us.es
#
# File: init script
# Purpose: defines the steps to set up the scenario
############################ # ############################

#!/bin/bash

## Create namespace 's02-exercise-03-p01'
kubectl create ns s02-exercise-03-p01

## Use it as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=s02-exercise-03-p01
# Check it by `kubectl config view --minify`

# Delete previously created pvc
# kubectl delete pvc --all

## Create all resources (in order: db master, frontend)
kubectl create -f ./resources/mariadb-master
kubectl create -f ./resources/mariadb-slave
kubectl create -f ./resources/wordpress


# Remove everything created
# kubectl delete ns s02-exercise-03-p01