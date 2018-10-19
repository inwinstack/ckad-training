#!bin/bash

#create secret pass
kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD

#verify secrets
kubectl get secrets

#deploy mariadb
kubectl create -f mariadb-deploy.yaml

#verify volumes
kubectl get pvc

#verify pods
kubectl get pods

#deploy wordpress
kubectl create -f wordpress-deploy.yaml

#verify services
kubectl get services wordpress

#deploy drupal
kubectl create -f drupal-deploy.yaml

#network policy
kubectl create -f network-policy.yaml

#ingress
kubectl create -f ingress.yaml