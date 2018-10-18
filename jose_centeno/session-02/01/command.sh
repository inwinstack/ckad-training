#!/bin/bash
NAMESPACE="exercise-01"
# Step 1: Create the ns 
kubectl create ns $NAMESPACE

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
kubectl config set-context kubernetes-admin@kubernetes --namespace=$NAMESPACE

# Create the configuration 
kubectl create -f myconfigs-cm.yaml -f myconfigs-secret.yaml 
kubectl create -f nginx-headless-svc.yaml

# Create mariaDB Service
kubectl create -f mariadb-services.yaml
#kubectl create -f mariadb-svc.yaml
echo "Waiting MariaDB is ready"
while [ "$(kubectl get endpoints mariadb -o=jsonpath={.subsets})" == "" ]; do echo -n "."; sleep 1; done
echo " "

#Create drupal service
kubectl create -f drupal-services.yaml
#kubectl create -f drupal-svc.yaml


# Create Wordpress Service
kubectl create -f wordpress-services.yaml
#kubectl create -f wordpress-svc.yaml

# Add ingress rules
mkdir tls
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls/myblog-com-tls.key -out ./tls/myblog-com-tls.crt -subj "/CN=myblog.com"
kubectl create secret tls myblog-com-secret-tls --key tls/myblog-com-tls.key --cert tls/myblog-com-tls.crt
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls/drupal-myblog-com-tls.key -out ./tls/drupal-myblog-com-tls.crt -subj "/CN=drupal.myblog.com"
kubectl create secret tls drupal-myblog-com-secret-tls --key tls/drupal-myblog-com-tls.key --cert tls/drupal-myblog-com-tls.crt
kubectl apply -f ingress.yaml 

### Wait until (wordpress) services are ready
while [ "$(kubectl get endpoints myblog-wordpress -o=jsonpath={.subsets})" == "" ] ; do echo "."; sleep 1; done
echo "Waiting until wordpress is ready"
until kubectl logs $(kubectl get pods -ltier=frontend,app=myblog-wordpress -o=jsonpath="{.items[0].metadata.name}") | grep "Starting wordpress..."; do echo -n "."; sleep 1; done
echo " "

echo "To access wordPress you can use:"
echo "http://myblog.com/"
echo "http://kubernetes:$(kubectl get svc myblog-wordpress -o=jsonpath={.spec.ports[0].nodePort})"


echo "To access drupal you can use:"
echo "http://drupal.myblog.com/drupal"
while [ "$(kubectl get endpoints myblog-drupal -o=jsonpath={.subsets})" == "" ] ; do echo "."; sleep 1; done
echo "http://kubernetes:$(kubectl get svc myblog-drupal -o=jsonpath={.spec.ports[0].nodePort})"


# Delete all resources
#kubectl delete ns exercise-01