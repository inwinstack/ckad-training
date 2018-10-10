#!/bin/bash

# Step 1: Create the ns 
kubectl create ns exercise-01

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
kubectl config set-context kubernetes-admin@kubernetes --namespace=exercise-01

# Create the configuration 
kubectl create -f cm.yaml -f secret.yaml 

# Create mariaDB Service
## Create mariaDB deployment
kubectl create -f mariadb-deployment.yaml
### Check that mariaDB pod is correct
#kubectl get pods
### Chech mariaDB logs (1st pod)
#kubectl logs $(k get pods -lapp=myblog,tier=backend -o jsonpath="{.items[0].metadata.name}")
## Create mariaDB clusterIP service to be reached from wordpress
kubectl create -f mariadb-svc.yaml 

# Create Wordpress Service
## Create the deployment
kubectl create -f wordpress-deployment.yaml
## Create the deployment of the canary
kubectl create -f wordpress-canary-deployment.yaml 

### Check that te pods are ok
#kubectl get pods -lapp=myblog,l=tier=frontend
## Create the LoadBalancer service (it will not be able to assign an external IP)
kubectl create -f wordpress-svc.yaml

# Delete all resources
#kubectl delete ns exercise-01