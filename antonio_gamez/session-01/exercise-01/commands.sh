#!/bin/bash

## Create UI (if desired)
# kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
## then go to: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/

## Create ns 'exercise-01'
kubectl create ns exercise-01

## Use it as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=exercise-01
# Check it by `kubectl config view --minify`

## Create all resources
kubectl create -f ./resources

