#!/bin/bash

# Step 1: Create the ns 
kubectl create ns exercise-01

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
alias k="kubectl -n exercise-01"

# Create the configuration 
k create -f cm.yaml -f secret.yaml 

# Create mariaDB Service
## Create mariaDB deployment
k create -f mariadb-deployment.yaml
### Check that mariaDB pod is correct
k get pods
### Chech mariaDB logs (1st pod)
k logs $(k get pods -lapp=myblog,tier=backend -o jsonpath="{.items[0].metadata.name}")
## Create mariaDB clusterIP service to be reached from wordpress
k create -f mariadb-svc.yaml 

# Create Wordpress Service
## Create the deployment
k create -f wordpress-deployment.yaml
## Create the deployment of the canary
 k create -f wordpress-canary-deployment.yaml 

### Check that te pods are ok
k get pods -lapp=myblog,l=tier=frontend
## Create the LoadBalancer service (it will not be able to assign an external IP)
k create -f wordpress-svc.yaml

# Delete all resources
k delete ns exercise-01