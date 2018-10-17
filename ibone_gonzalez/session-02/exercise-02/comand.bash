# create namespace
kubectl create ns exercise02

# create secrest
kubectl create secret generic mariadb-password --from-literal=password=root --namespace=exercise02
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise02
kubectl create secret generic wordpress-password --from-literal=password=user --namespace=exercise02

# create config map
kubectl create -f exercise02-cm.yaml

# create pvc
kubectl create -f mariadb-pvc.yaml
kubectl create -f wordpress-pvc.yaml

# create deployments
kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml

# create services
kubectl create -f mariadb-service.yaml
kubectl create -f wordpress-service.yaml

# create job
kubectl create -f job-cm.yaml
kubectl create -f job.yaml