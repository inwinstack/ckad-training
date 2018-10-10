#!/bin/bash
PS3='Please enter your choice: '
options=("Create ns" "Create secrets" "Create services"  "Create Deployments" "Create All" "Delete all" "Quit")
select opt in "${options[@]}"

 case "$opt" in
    "${options[0]}")
        ## Create ns
        kubectl create ns exercise01
        ;;

## Create secrets
#kubectl create secret generic 
kubectl create -f cm.yaml
## Create service
kubectl create -f wordpress-svc.yaml
kubectl create -f mariadb-svc.yaml

## Create deployment
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml

kubectl create -f mariadb-deployment.yaml

## port-forward
kubectl port-forward $(kubectl get pods -l app=wordpress,version=stable -o jsonpath="{.items[0].metadata.name}" --namespace=exercise01) 8080:80 --namespace=exercise01 &

 #       "Quit")
 #           break
 #           ;;
 #*) echo "invalid option $REPLY";;
#esac
#done