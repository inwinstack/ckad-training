#!/bin/bash

#set -x

function randomgen {
	# Default values
    if [ -z $1 ]; then
        MODE=10
    else
        MODE=$1
    fi
    if [ -z $2 ]; then
        MIN_NUM=10
    else
        MIN_NUM=$2
    fi
    if [ -z $3 ]; then
        MAX_NUM=22
    else
        MAX_NUM=$3
    fi
    if [ -z $4 ]; then
        FILE_NAME="places.txt"
    else
        FILE_NAME=$4
    fi
    if [ -z $5 ]; then
        URL_LIST="https://raw.githubusercontent.com/Tedezed/random-name/master/places.txt"
    else
        URL_LIST=$5
    fi

    if [ "$MODE" = "name" ];  then
        if [ ! -f $FILE_NAME ]; then
            curl -SL $URL_LIST -o $FILE_NAME
        fi
        MAX_LINES=$(cat $FILE_NAME | wc -l)
        SUB_NUM=$((MAX_LINES - MIN_NUM))
        RANDOM_LINE=$(echo $RANDOM %$SUB_NUM +$MIN_NUM | bc)
        echo $(sed "${RANDOM_LINE}q;d" $FILE_NAME | sed 's#\r##g')
    else
        SUB_NUM=$((MAX_NUM - MIN_NUM))
        echo $(openssl rand -hex $(echo $RANDOM %$SUB_NUM +$MIN_NUM | bc))
    fi
}

MARIADB_USER_NAME=$(randomgen "name")
MARIADB_USER_PASS=$(randomgen "x" 6 12)
MARIADB_REPLICATION_USER=$(randomgen "name")
MARIADB_REPLICATION_PASS=$(randomgen "x" 6 12)
MARIADB_ROOT_PASS=$(randomgen "x" 6 12)

GENERIC_USER=$(randomgen "name")
GENERIC_EMAIL="$(randomgen "name")@example.com"
GENERIC_PASS=$(randomgen "x" 6 12)

kubectl create namespace exercise-01

kubectl create secret generic secret-mariadb -n exercise-01 \
	--from-literal=mariadb_user=$MARIADB_USER_NAME \
	--from-literal=mariadb_password=$MARIADB_USER_PASS \
    --from-literal=mariadb_replication_user=$MARIADB_REPLICATION_USER \
	--from-literal=mariadb_replication_password=$MARIADB_REPLICATION_PASS \
	--from-literal=mariadb_root_password=$MARIADB_ROOT_PASS

kubectl create secret generic secret-wordpress -n exercise-01 \
    --from-literal=wordpress_username=$GENERIC_USER \
    --from-literal=wordpress_email=$GENERIC_EMAIL \
    --from-literal=wordpress_password=$GENERIC_PASS

kubectl create secret generic secret-drupal -n exercise-01 \
    --from-literal=drupal_username=$GENERIC_USER \
    --from-literal=drupal_email=$GENERIC_EMAIL \
    --from-literal=drupal_password=$GENERIC_PASS

kubectl create -f conf/cm.yaml

# MARIADB
kubectl create -f mariadb/mariadb.yaml

# WORDPRESS
kubectl create -f wordpress/wordpress-svc.yaml
kubectl create -f wordpress/wordpress-deployment.yaml

# DRUPAL
kubectl create -f drupal/drupal-svc.yaml
kubectl create -f drupal/drupal-deployment.yaml

# NETPOL
kubectl create -f conf/netpol.yaml

# CERT-MANAGER
#kubectl create namespace cert-manager
#kubectl create -f cert-manager/sa.yaml
#kubectl create -f cert-manager/cert-manager.yaml

openssl req -x509 -nodes -days 100 -subj "/CN=wordpress.example.es" -newkey rsa:1024 -keyout cert/wordpress.key -out cert/wordpress.crt
openssl req -x509 -nodes -days 100 -subj "/CN=drupal.example.es" -newkey rsa:1024 -keyout cert/drupal.key -out cert/drupal.crt
kubectl create secret tls wordpress-tls --key cert/wordpress.key  --cert cert/wordpress.crt -n exercise-01
kubectl create secret tls drupal-tls --key cert/drupal.key  --cert cert/drupal.crt -n exercise-01

# INGRESS
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
kubectl create -f conf/ingress-svc.yaml

kubectl create -f wordpress/wordpress-ingress.yaml
kubectl create -f drupal/drupal-ingress.yaml

echo "
Credentials:
    MARIADB_USER_NAME: $MARIADB_USER_NAME
    MARIADB_USER_PASS: $MARIADB_USER_PASS
    MARIADB_REPLICATION_PASS: $MARIADB_REPLICATION_PASS
    MARIADB_ROOT_PASS: $MARIADB_ROOT_PASS
    WORDPRESS_USER: $GENERIC_USER
    WORDPRESS_EMAIL: $GENERIC_EMAIL
    WORDPRESS_PASS: $GENERIC_PASS
Domain:
    wordpress.example.es
    drupal.example.es
"

# Domain
IP_KUBERNETES=$(ping kubernetes -w 1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
echo "Add domains with IP $IP_KUBERNETES to /etc/hosts..."
sudo bash -c "cat /etc/hosts | grep -v "\""wordpress.example.es\|drupal.example.es"\"" > /etc/hosts.new \
    && cp /etc/hosts /etc/hosts.old \
    && mv /etc/hosts.new /etc/hosts \
    && echo "\""$IP_KUBERNETES    wordpress.example.es"\"" >> /etc/hosts \
    && echo "\""$IP_KUBERNETES    drupal.example.es"\"" >> /etc/hosts"