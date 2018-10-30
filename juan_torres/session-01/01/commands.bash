#!/bin/bash

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

    SUB_NUM=$((MAX_NUM - MIN_NUM))
    if [ "$MODE" = "name" ];  then
        curl -SL $URL_LIST -o $FILE_NAME
        RANDOM_LINE=$(echo $RANDOM %$SUB_NUM +$MIN_NUM | bc)
        MAX_LINES=$(cat $FILE_NAME | wc -l)
        echo $(sed "${RANDOM_LINE}q;d" )
    else
        echo $(openssl rand -hex $(echo $RANDOM %$SUB_NUM +$MIN_NUM | bc))
    fi
}

MARIADB_USER_NAME=$(randomgen "name")
MARIADB_USER_PASS=$(randomgen "x" 6 12)
MARIADB_ROOT_PASS=$(randomgen "x" 6 12)
WORDPRESS_PASS=$(randomgen "x" 6 12)

kubectl create -f namespace.yaml

kubectl create secret generic secret-mariadb -n exercise-01 \
    --from-literal=mariadb_user=$MARIADB_USER_NAME \
	--from-literal=mariadb_password=$MARIADB_USER_PASS \
	--from-literal=mariadb_root_password=$MARIADB_ROOT_PASS

kubectl create secret generic secret-wordpress -n exercise-01 \
	--from-literal=wordpress_password=$WORDPRESS_PASS

kubectl create -f cm.yaml

kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml

kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml
sleep 10
kubectl create -f wordpress-canary-deployment.yaml

echo "Credentials:
        MARIADB_USER_NAME: $MARIADB_USER_NAME
	MARIADB_USER_PASS: $MARIADB_USER_PASS
	MARIADB_ROOT_PASS: $MARIADB_ROOT_PASS
	WORDPRESS_PASS: $WORDPRESS_PASS
"