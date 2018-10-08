# get namespaces
kubectl get ns

# create namespaces
kubectl create ns exercise02

# create secrets 
kubectl create secret generic mariadb --from-literal=password=root --namespace=exercise02
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise02
kubectl create secret generic mariadb-pass-replication-user --from-literal=password=user --namespace=exercise02

#create deplyments
kubectl create -f mariadb-master-deployment.yaml
kubectl create -f mariadb-master-svc.yaml
kubectl create -f mariadb-slave-deployment.yaml
kubectl create -f mariadb-slave-svc.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml

#Scale slaves to 5 replicas already have 3
kubectl scale deployment mariadb-slave-deployment --replicas=5