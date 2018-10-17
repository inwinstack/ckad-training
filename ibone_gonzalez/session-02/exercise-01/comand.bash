# create namespace
kubectl create ns exercise01

# create secret
kubectl create secret generic mariadb-password --from-literal=password=root --namespace=exercise01
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise01
kubectl create secret generic wordpress-password --from-literal=password=user --namespace=exercise01
kubectl create secret generic wordpress-password-database --from-literal=password=user --namespace=exercise01

# create config map
kubectl create -f exercise01-cm.yaml

# create pvc
kubectl create -f mariadb-pvc.yaml
kubectl create -f drupal-pvc.yaml
kubectl create -f wordpress-pvc.yaml

# create deployments
kubectl create -f mariadb-deployment.yaml
kubectl create -f drupal-deployment.yaml
kubectl create -f wordpress-deployment.yaml


# create services
kubectl create -f mariadb-service.yaml
kubectl create -f drupal-service.yaml
kubectl create -f wordpress-service.yaml

# create tls
kubectl create secret generic auth-tls-chain --from-file=cert.crt --namespace=exercise01

# create ingress
kubectl create -f wordpress-ingress.yaml
kubectl create -f drupal-ingress.yaml