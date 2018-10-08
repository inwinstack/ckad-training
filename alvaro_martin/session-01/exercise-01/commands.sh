#!/bin/bash

#export SANDBOX_IP=54.227.233.69
#export KUBECONFIG=~/.kube/sandbox.conf

NAMESPACE='exercise-01'

#echo "${SANDBOX_IP}   kubernetes" | sudo tee -a /etc/hosts

## Create NAMESPACE
kubectl create ns ${NAMESPACE}

## Create CONFIGMAP (only to configure apps -> env)
# kubectl create cm mariadbcm --from-file=./MariaDBCM.yaml
kubectl create -f mariadb-configmap.yaml
kubectl create -f wordpress-configmap.yaml

# Check if CM is fine
#kubectl get configmaps mariadbcm -o yaml
#kubectl describe cm mariadbcm

## Create SECRETS
# kubectl create secret generic mariapass --from-literal=password=root
# kubectl create secret generic wppass --from-literal=password=root

# Need to attach them to a NS as well, so we use a file
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml

# To check NS
# echo $(kubectl get secret mariapass -o json | jq -r '.data.password' | base64 --decode)
# echo $(kubectl get secret wppass -o json | jq -r '.data.password' | base64 --decode)

# Create MariaDB
kubectl create -f mariadb-deployment.yaml
# Create internal service
kubectl create -f mariadb-svc.yaml

# Internal check of MariaDB
#kubectl exec -it POD CONTAINER -- mysql -u bn_wordpress -pwp-root wp-database
#kubectl -n exercise-01 exec -it mariadb-777545c8f-9wkd6 -- mysql -ubn_wordpress -prootroot bitnami_wordpress
#kubectl -n exercise-01 exec -it mariadb-777545c8f-9wkd6 -- mysql -uroot -prootroot bitnami_wordpress

# Create Wordpress deployment
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml
# Create external service
kubectl create -f wordpress-svc-lb.yaml
#kubectl create -f wordpress-svc-nodeport.yaml

# Internal check of wordpresscm

# To remove everything
##kubectl delete ns/exercise-01
