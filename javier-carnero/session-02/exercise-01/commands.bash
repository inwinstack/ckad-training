#!/bin/bash
set -e

kubectl create namespace exercise-01

kubectl create -f cm.yaml

kubectl create secret generic database-credentials -n exercise-01 \
--from-literal=root-password=mariapower \
--from-literal=wp-dbname=wordpress \
--from-literal=wp-user=wordpress \
--from-literal=wp-password=wordpresspower \
--from-literal=dr-dbname=drupal \
--from-literal=dr-user=drupal \
--from-literal=dr-password=drupalpower
kubectl create secret generic wp-credentials -n exercise-01 \
--from-literal=user=kubernetes \
--from-literal=password=training
kubectl create secret generic dr-credentials -n exercise-01 \
--from-literal=user=drupal \
--from-literal=password=training

kubectl create --save-config -f wordpress-pvc.yaml
kubectl create --save-config -f drupal-pvc.yaml

kubectl create --save-config -f mariadb-np.yaml

kubectl create --save-config -f mariadb-headless-svc.yaml
kubectl create --save-config -f mariadb-statefulset.yaml
kubectl create --save-config -f mariadb-svc.yaml

kubectl create --save-config -f wordpress-deployment.yaml
kubectl create --save-config -f wordpress-svc.yaml

kubectl create --save-config -f drupal-deployment.yaml
kubectl create --save-config -f drupal-svc.yaml

if [ ! -d "key/wp" ]; then
    mkdir -p key/wp
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=myblog.com" -keyout key/wp/tls.key -out key/wp/tls.crt
fi
kubectl create secret tls wp-sslcerts --namespace="exercise-01" --key key/wp/tls.key --cert key/wp/tls.crt

if [ ! -d "key/dp" ]; then
    mkdir -p key/dp
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=drupal.myblog.com" -keyout key/dp/tls.key -out key/dp/tls.crt
fi
kubectl create secret tls dp-sslcerts --namespace="exercise-01" --key key/dp/tls.key --cert key/dp/tls.crt

kubectl create --save-config -f ingress.yaml


# Access via browser to:
echo ""
echo "---------------------------------"
echo "Add your node IP to /etc/hosts, with the following entries:"
echo "\$CLUSTER_NODE_IP kubernetes"
echo "\$CLUSTER_NODE_IP myblog.com"
echo "\$CLUSTER_NODE_IP drupal.myblog.com"
echo ""
echo "---------------------------------"
echo "After a few minutes access to:"
echo "Wordpress: https://myblog.com"
echo "Drupal: https://drupal.myblog.com"  # TODO: /drupal
