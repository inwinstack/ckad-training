#!/bin/bash

echo "Creating namespace exercise-01 ..."
kubectl create -f namespace.yaml

echo "Creating a secret value for the mariadb password ..."
kubectl -n exercise-01 create secret generic exercise-01-secret \
    --from-literal=mariadb_password=BITNAMIRULES \
    --from-literal=mariadb_root_password=IAMROOT

echo "Creating a configmap to store the values ... "
kubectl create -f configmap.yaml

echo "Creating the deployments for mariadb and wordpress (including canary deployment) ..."
kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml

echo "Creating the necessary services to expose the application ..."
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml

echo """
############################################################################################################################################################
############################################################################################################################################################
                                                                                                                                         
        Stable WordPress: http://kubernetes:$(kubectl -n exercise-01 get svc wordpress-service -o jsonpath='{.spec.ports[0].nodePort}')
                                                                                                                                            
        Unstable WordPress: http://kubernetes:$(kubectl -n exercise-01 get svc wordpress-service-canary -o jsonpath='{.spec.ports[0].nodePort}')
                                                                                                                                              
############################################################################################################################################################
############################################################################################################################################################

NOTE: The URL's will be available in approximately 1 minute... :-)

"""
