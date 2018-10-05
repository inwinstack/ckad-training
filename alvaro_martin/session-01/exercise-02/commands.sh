#!/bin/bash

#export SANDBOX_IP=52.207.244.48
#export KUBECONFIG=~/.kube/sandbox.conf

NAMESPACE='exercise-02'

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
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f mariadb-slave-svc.yaml

# Internal check of MariaDB
#kubectl exec -it POD CONTAINER -- mysql -u bn_wordpress -pwp-root wp-database
#kubectl -n exercise-02 exec -it POD -- mysql -ubn_wordpress -prootroot bitnami_wordpress
#kubectl -n exercise-02 exec -it POD -- mysql -uroot -prootroot bitnami_wordpress

# Create Wordpress deployment
kubectl create -f wordpress-deployment.yaml
# Create external service
kubectl create -f wordpress-svc.yaml

# HOW TO

## At least 60% of the replicas will be available on rolling updates on slaves
## Based on https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment
# .spec.strategy.rollingUpdate.maxUnavailable should be set to 40%
# We can do this inside the yaml file, or on the fly

## Scale slaves to 5 replicas.
## Based on the same doc
kubectl scale deployment mariadb-slave --replicas=5

## steps to follow to install HyperDB WP plugin and configure it to balance SQL
## request between Master&Slaves services
# Can't do it, my wordpress pod doesn't start. It says OOM error, and it's weird
# because it's always the wp pod and not any mariadb pod. It's also true that
# it's the last one on being created.

# To remove everything
# kubectl delete ns/exercise-02
