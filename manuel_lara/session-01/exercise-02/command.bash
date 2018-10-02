#!/bin/bash

set -e

HOME=$( cd -P "$( dirname "${BASH_SOURCE[0]}}" )" && pwd )

create_resource () {
    file=$1

    kubectl apply -f $file
}

create_tunnel () {
    ip_regex=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}

    until [[ $(kubectl describe svc wordpress --namespace=exercise-02 | grep Endpoints:) =~ $ip_regex ]]; do
        printf '.'
        sleep 5
    done

    printf '\n'
    kubectl port-forward $(kubectl get pods -l app=exercise-02,tier=frontend -o jsonpath="{.items[0].metadata.name}" --namespace=exercise-02) 8080:80 --namespace=exercise-02
}

echo "Cretaing an isolate namespace..."
kubectl apply -f $HOME/namespace.yml

echo "Setting up some configuration values"
kubectl apply -f $HOME/configMap.yml
kubectl apply -f $HOME/secret.yml

echo "Deploying the application services..."
kubectl apply -f $HOME/deployment.yml

echo "Setting up the autoscalling..."
kubectl apply -f $HOME/horizontalPodAutoscaler.yml

echo "Exposing the application..."
kubectl apply -f $HOME/service.yml

echo "Preparing the blog..."
create_tunnel