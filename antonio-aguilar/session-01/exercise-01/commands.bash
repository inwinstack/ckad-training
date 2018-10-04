#!/bin/bash 

# Create ns
kubectl create ns exercise-01

# Create configMap
kubectl create -f cm.yml

# Deploy backend
kubectl create -f mariadb-deployment.yml
kubectl describe deployment mariadb -n exercise-01 
kubectl create -f mariadb-svc.yml
kubectl get services -n exercise-01

# Deploy frontend
kubectl create -f wordpress-deployment.yml
kubectl describe deployment wp-deployment -n exercise-01
kubectl create -f wordpress-svc.yml
kubectl get services -n exercise-01

# Access container to debugging 
# kubectl -n exercise-01 exec -it <pod name> -- /bin/bash

# Delete namespace
kubectl delete namespace exercise-01