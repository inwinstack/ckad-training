#!/bin/bash
NAMESPACE="exercise-02"
# Step 1: Create the ns 
kubectl create ns $NAMESPACE

#Create an alias to set the namespace automaticaly, it can also be done on kube config.
kubectl config set-context kubernetes-admin@kubernetes --namespace=$NAMESPACE

# Create the configuration 
kubectl create -f cm.yaml -f secret.yaml 

# Create mariaDB Service
## Create mariaDB deployment and services
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
while [ "$(kubectl get endpoints myblog-mariadb-master -o=jsonpath={.subsets})" == "" ]; do echo "."; sleep 1; done
kubectl create -f mariadb-slave-deployment.yaml 
kubectl create -f mariadb-slave-svc.yaml 
### Check that mariaDB pod is correct
#kubectl get pods
### Check mariaDB master logs
#kubectl logs $(kubectl get pods -ltier=backend,role=master -o jsonpath="{.items[0].metadata.name}")
### Check mariaDB slave logs (1st pod)
#kubectl logs $(kubectl get pods -ltier=backend,role=slave -o jsonpath="{.items[0].metadata.name}")

# Create Wordpress Service
## Create the deployment
kubectl create -f wordpress-deployment.yaml

### Check that te pods are ok
#kubectl logs $(kubectl get pods -ltier=frontend -o=jsonpath="{.items[0].metadata.name}") -f
## Create the LoadBalancer service (it will not be able to assign an external IP)
kubectl create -f wordpress-svc.yaml
while [ "$(kubectl get endpoints myblog-wordpress -o=jsonpath={.subsets})" == "" ] ; do echo "."; sleep 1; done
echo "Waiting until wordress is ready"
until kubectl logs $(kubectl get pods -ltier=frontend -o=jsonpath="{.items[0].metadata.name}") | grep "Starting wordpress..."; do echo "."; sleep 1; done
echo "http://kubernetes:$(kubectl get svc myblog-wordpress -o=jsonpath={.spec.ports[0].nodePort})"

# Delete all resources
#kubectl delete ns exercise-01