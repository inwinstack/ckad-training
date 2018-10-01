#!/bin/bash

## Create UI (if desired)
# kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
## then go to: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/

## Create ns 'exercise-02'
kubectl create ns exercise-02

## Use it as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=exercise-02
# Check it by `kubectl config view --minify`

## Create all resources
kubectl create -f ./resources

# Scale up to 5 all the MariaDB slaves
kubectl scale -l "app=wordpress,tier=database,mode=slave" --replicas=5

