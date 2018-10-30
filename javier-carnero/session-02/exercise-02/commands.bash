#!/bin/bash
set -e

kubectl create namespace exercise-02

kubectl create -f cm.yaml

kubectl create secret generic database-credentials -n exercise-02 \
--from-literal=root-password=mariapower \
--from-literal=wp-dbname=wordpress \
--from-literal=wp-user=wordpress \
--from-literal=wp-password=wordpresspower
kubectl create secret generic wp-credentials -n exercise-02 \
--from-literal=user=kubernetes \
--from-literal=password=training

kubectl create --save-config -f wordpress-pvc.yaml
kubectl create --save-config -f backup-pvc.yaml

kubectl create --save-config -f mariadb-np.yaml

kubectl create --save-config -f mariadb-headless-svc.yaml
kubectl create --save-config -f mariadb-statefulset.yaml
kubectl create --save-config -f mariadb-svc.yaml

kubectl create --save-config -f wordpress-deployment.yaml
kubectl create --save-config -f wordpress-svc.yaml

if [ ! -d "key/wp" ]; then
    mkdir -p key/wp
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=myblog.com" -keyout key/wp/tls.key -out key/wp/tls.crt
fi
kubectl create secret tls wp-sslcerts --namespace="exercise-02" --key key/wp/tls.key --cert key/wp/tls.crt

kubectl create --save-config -f ingress.yaml

kubectl create -f backup-cronjob.yaml

# Access via browser to:
echo ""
echo "---------------------------------"
echo "Add your node IP to /etc/hosts, with the following entries:"
echo "\$CLUSTER_NODE_IP kubernetes"
echo "\$CLUSTER_NODE_IP myblog.com"
echo ""
echo "---------------------------------"
echo "After a few minutes access to:"
echo "Wordpress: https://myblog.com"
