#!/bin/bash

## Create wp
kubectl create -f  wordpress-deployment.yaml

## Create db
kubectl create -f  mariadb-deployment.yaml

## Create config map
kubectl create configmap my_config_map --from-file=*

## Create secrete
kubectl create secret generic wordpress --from-literal=WORDPRESS_PASSWORD=password

## Create canary deployment
kubectl create -f  /wordpress-canary-deployment.yaml

## The probes are in the deployment files included
## The resources management are in the deployment files included

## Monitoring
kubectl describe pod wordpress | grep -A 3 Events

## Create Services
kubectl create -f  wordpress-svc.yaml
kubectl create -f  mariadb-svc.yaml

## adding Hyperdb to wordpress pending



