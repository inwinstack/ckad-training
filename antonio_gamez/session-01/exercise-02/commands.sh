############################ # ############################
## Bitnami K8S training
## session01/exercise02
#
## Author: Antonio Gamez-Diaz
## Contact: antoniogamez@us.es
#
# File: init script
# Purpose: defines the steps to set up the scenario
############################ # ############################

#!/bin/bash

## Create UI (if desired)
# kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
## then go to: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/

# Prerequisite: compile go sources in order to have kubeseal

# Configure sealed-secrets environment (CRD + controller)
#kubectl create -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.7.0/sealedsecret-crd.yaml
#kubectl create -f https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.7.0/controller.yaml

# Exporting secrets to json (we suppose these *-secret.yaml are being ignored by the CVS)
#kubectl create --dry-run  -f ./resources/mariadb-master/mariadb-secret.yaml -o json > mariadb-secret.json
#kubectl create --dry-run  -f ./resources/wordpress/wordpress-secret.yaml -o json > wordpress-secret.json

# Encrypting secrets with the cluster key
#kubeseal < ./resources/mariadb-master/mariadb-secret.json > ./resources/mariadb-master/mariadb-sealedsecret.json
#kubeseal < ./resources/wordpress/wordpress-secret.json > ./resources/wordpress/wordpress-sealedsecret.json

# Using the encrypted secrets (safe in the CVS) to create the resources
#kubectl create --f ./resources/mariadb/mariadb-sealedsecret.json
#kubectl create --f ./resources/wordpress/wordpress-sealedsecret.json


## Create ns 'exercise-02'
kubectl create ns exercise-02

## Use it as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=exercise-02
# Check it by `kubectl config view --minify`

## Create all resources (in order: db master, db slave, frontend)
kubectl create -f ./resources/mariadb-master
kubectl create -f ./resources/mariadb-slave
kubectl create -f ./resources/wordpress

# Scale up to 5 all the MariaDB slaves
kubectl scale -l "app=wordpress,tier=database,mode=slave" --replicas=5

# Remove everything created
# kubectl delete -f ./resources -R
