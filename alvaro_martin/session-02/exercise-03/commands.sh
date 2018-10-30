#!/bin/bash

#export SANDBOX_IP=54.165.149.251
#export KUBECONFIG=~/.kube/sandbox.conf

NAMESPACE='exercise-03'

#echo "${SANDBOX_IP}   kubernetes" | sudo tee -a /etc/hosts

## Create NAMESPACE
kubectl create ns ${NAMESPACE}

## Create CONFIGMAP (only to configure apps -> env)
kubectl create -f mariadb-configmap.yaml
kubectl create -f wordpress-configmap.yaml

# Check if CM is fine
#kubectl get configmaps mariadbcm -o yaml
#kubectl describe cm mariadbcm

## Create SECRETS
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml

## Create PVCs
kubectl create -f mariadb-pvc.yaml
kubectl create -f wordpress-pvc.yaml
kubectl create -f backup-pvc.yaml

# To check NS
# echo $(kubectl get secret NAME -o json | jq -r '.data.password' | base64 --decode)

# Create MariaDB
kubectl create -f mariadb-statefulset.yaml
kubectl create -f mariadb-svc.yaml

# Internal check of MariaDB
#kubectl exec -it POD CONTAINER -- mysql -u bn_wordpress -pwp-root wp-database
#kubectl -n exercise-02 exec -it POD -- mysql -ubn_wordpress -prootroot bitnami_wordpress
#kubectl -n exercise-02 exec -it POD -- mysql -uroot -prootroot bitnami_wordpress

# Create Wordpress deployment
kubectl create -f wordpress-deployment.yaml
# Create external service
kubectl create -f wordpress-svc.yaml


# To remove everything
#kubectl delete ns/${NAMESPACE}
