#!/bin/bash

#export SANDBOX_IP=54.165.149.251
#export KUBECONFIG=~/.kube/sandbox.conf

NAMESPACE='exercise-01'

#echo "${SANDBOX_IP}   kubernetes" | sudo tee -a /etc/hosts

# TLS generation
# https://kubernetes.github.io/ingress-nginx/user-guide/tls/
KEY_FILE="myKey"
CERT_FILE="myCert"
CERT_NAME="tls-secret-amr"
HOST=54.165.149.251
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"
#kubectl create secret tls ${CERT_NAME} --key ${KEY_FILE} --cert ${CERT_FILE}

## Create NAMESPACE
kubectl create ns ${NAMESPACE}

## Create CONFIGMAP (only to configure apps -> env)
kubectl create -f mariadb-configmap.yaml
kubectl create -f wordpress-configmap.yaml
kubectl create -f drupal-configmap.yaml

# Check if CM is fine
#kubectl get configmaps mariadbcm -o yaml
#kubectl describe cm mariadbcm

## Create SECRETS
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f drupal-secret.yaml
kubectl create -f ingress-secret.yaml

## Create PVCs
kubectl create -f mariadb-pvc.yaml
kubectl create -f wordpress-pvc.yaml
kubectl create -f drupal-pvc.yaml

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

# Create Drupal deployment
kubectl create -f drupal-deployment.yaml
# Create external service
kubectl create -f drupal-svc.yaml

# Create Ingress
kubectl create -f myblog-ingress.yaml

# To delete default ingress rule (to dashboard)
# kubectl get ingress --all-namespaces=true
# kubectl delete ingress external-auth-oauth2 -n kube-system



# To remove everything
#kubectl delete ns/exercise-01
