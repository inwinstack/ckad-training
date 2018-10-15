# get namespace
kubectl get ns
# create namespace
kubectl create ns exercise01

# create secrest
kubectl create secret generic mariadb --from-literal=password=root --namespace=exercise01
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise01

# create configMap
kubectl create -f cm.yaml

# create deployments and services 
kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f wordpress-canary-deployment.yaml

# delete namespace
kubectl delete ns exercise01

