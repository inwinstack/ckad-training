#!/bin/bash
NAMESPACE="exercise-03"
# Step 1: Create the ns 
kubectl create ns $NAMESPACE

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
kubectl config set-context kubernetes-admin@kubernetes --namespace=$NAMESPACE

# Create the configuration 
kubectl create -f myconfigs-cm.yaml -f myconfigs-secret.yaml 
kubectl create -f nginx-headless-svc.yaml

# Create mariaDB Service
kubectl create -f mariadb-services.yaml
echo "Waiting MariaDB is ready"
while [ "$(kubectl get endpoints mariadb -o=jsonpath={.subsets})" == "" ]; do echo -n "."; sleep 1; done
echo " "

# Create Wordpress Service
kubectl create -f wordpress-services.yaml

### Wait until (wordpress) services are ready
while [ "$(kubectl get endpoints myblog-wordpress -o=jsonpath={.subsets})" == "" ] ; do echo "."; sleep 1; done
echo "Waiting until wordpress is ready"
until kubectl logs $(kubectl get pods -ltier=frontend,app=myblog-wordpress -o=jsonpath="{.items[0].metadata.name}") -c wordpress | grep "Starting wordpress..."; do echo -n "."; sleep 1; done
echo " "

echo "To access wordPress you can use:"
echo "http://kubernetes:$(kubectl get svc myblog-wordpress -o=jsonpath={.spec.ports[0].nodePort})"


# Delete all resources
#kubectl delete ns exercise-02