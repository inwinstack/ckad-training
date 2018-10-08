#!/bin/bash 

# Create ns
kubectl create ns exercise-01

# Create configMap
kubectl create -f cm.yml

# Create secrets
kubectl create secret generic wp-secret -n exercise-01 \
--from-literal=wp-password='donotenter'

kubectl create secret generic mariadb-secret -n exercise-01 \
--from-literal=mariadb-root-password='strongarm' \
--from-literal=mariadb-password='vivaerbeti#criaturitas'


# Deploy backend
kubectl create -f mariadb-deployment.yml
#kubectl describe deployment mariadb -n exercise-01 
kubectl create -f mariadb-svc.yml
#kubectl get services -n exercise-01

# Deploy frontend
kubectl create -f wordpress-deployment.yml
#kubectl describe deployment wp-deployment -n exercise-01
kubectl create -f wordpress-svc.yml
#kubectl get services -n exercise-01

# Access container to debugging 
# kubectl -n exercise-01 exec -it <pod name> -- /bin/bash

# Delete namespace
# kubectl delete namespace exercise-01
