#!/bin/bash

# Step 1: Create the ns 
kubectl create ns exercise-02

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
alias k="kubectl -n exercise-02"

# Create the configuration 
k create -f cm.yaml -f secret.yaml 

# Create mariaDB Service
## Create mariaDB deployment and services
k create -f mariadb-master-deployment.yaml
k create -f mariadb-master-svc.yaml
k create -f mariadb-slave-deployment.yaml 
k create -f mariadb-slave-svc.yaml 
### Check that mariaDB pod is correct
k get pods
### Check mariaDB master logs
k logs $(k get pods -ltier=backend,role=master -o jsonpath="{.items[0].metadata.name}")
### Check mariaDB slave logs (1st pod)
k logs $(k get pods -ltier=backend,role=slave -o jsonpath="{.items[0].metadata.name}")

# Create Wordpress Service
## Create the deployment
k create -f wordpress-deployment.yaml

### Check that te pods are ok
k logs $(k get pods -ltier=frontend -o jsonpath="{.items[0].metadata.name}") -f
## Create the LoadBalancer service (it will not be able to assign an external IP)
k create -f wordpress-svc.yaml

# Delete all resources
k delete ns exercise-01