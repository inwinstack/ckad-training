############################ # ############################
## Bitnami K8S training
## session03/exercise01
#
## Author: Antonio Gamez-Diaz
## Contact: antoniogamez@us.es
#
# File: init script
# Purpose: defines the steps to -manually- set up the scenario
############################ # ############################

#!/bin/bash

#################################################################################
######   IMPORTANT: This script is not (yet) prepared to run automatically  #####
#################################################################################


# Prerequisites:
#   - Helm. See https://helm.sh
#        > helm init
#   - A fully working nginx-ingress-controller is suppossed to be installed in the cluster.
#     If it is not, please follow this guide: https://kubernetes.github.io/ingress-nginx/deploy/
#     For Docker for Win/Mac, it is enough to enter these two commands:
#        > kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
#        > kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

# Go to the chart directory
cd wordpress-training

# Add bitnami chart repo
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update all repos
helm repo update

# Update requirements
helm dependency update

# Create namespace 's03-exercise-01' (wordpress)
kubectl create ns s03-exercise-01

# Create namespace 's03-exercise-02' (monitoring)
kubectl create ns s03-exercise-02


#################################################################################
######                              FIRST PART                              #####
#################################################################################

# Use 's03-exercise-01' as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=s03-exercise-01

# Install cert-manager for issuing TLS certificates
helm install --name cert-manager --namespace kube-system stable/cert-manager

# Install rbac objects (needed for the serviceAccount used in the WP plugin)
kubectl create -f './rbac/'

# Run the WordPress chart 
helm install . --namespace s03-exercise-01 --name wordpress


#################################################################################
######                             SECOND PART                              #####
#################################################################################

# Use 's03-exercise-02' as default in the context
kubectl config set-context $(kubectl config current-context) --namespace=s03-exercise-02

# Install elasticsearch
helm install stable/elasticsearch --namespace s03-exercise-02 --name elasticsearch --set master.replicas=2,data.replicas=1,client.replicas=1

# Install fluentd
helm install stable/fluentd-elasticsearch --namespace s03-exercise-02 --name fluentd --set elasticsearch.host=elasticsearch-client.s03-exercise-02.svc.cluster.local,elasticsearch.port=9200

# Install kibana
helm install stable/kibana --namespace s03-exercise-02 --name kibana --set env.ELASTICSEARCH_URL=http://elasticsearch-client.s03-exercise-02.svc:9200,env.SERVER_BASEPATH=/api/v1/namespaces/s03-exercise-02/services/kibana:443/proxy

# Install prometheus (note that the WP exporter is already preinstalled in the chart)
helm install stable/prometheus --namespace s03-exercise-02 --name prometheus -f '../monitoring/prometheus-values.yaml'

# Install grafana
helm install stable/grafana --namespace s03-exercise-02 --name grafana

# Install kubeapps
helm install bitnami/kubeapps --namespace kubeapps --name kubeapps 

#################################################################################
######                           WAIT FOR A WHILE                           #####
#################################################################################

# After waiting for a while, it is required to manually perform a port forwarding in order to get an internal access to each component

## Exposing Elasticseach
export POD_NAME=$(kubectl get pods --namespace s03-exercise-02 -l "app=elasticsearch,component=client,release=elasticsearch" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace s03-exercise-02 $POD_NAME 9200:9200
echo "Visit http://127.0.0.1:9200 to use Elasticsearch"
##

## Exposing Elasticseach
export POD_NAME=$(kubectl get pods --namespace s03-exercise-02 -l "app=kibana,release=kibana" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward --namespace s03-exercise-02 $POD_NAME 5601:5601
echo "Visit http://127.0.0.1:5601 to use Kibana"
##

## Exposing Prometheus
export POD_NAME=$(kubectl get pods --namespace s03-exercise-02 -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace s03-exercise-02 port-forward $POD_NAME 9090
echo "Visit http://127.0.0.1:9090 to use Prometheus"
### Remember that a WP metrics exporter is running at: https://<your_domain>/wp-json/metrics
##

## Exposing Grafana
export POD_NAME=$(kubectl get pods --namespace s03-exercise-02 -l "app=grafana,component=" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace s03-exercise-02 port-forward $POD_NAME 3000
echo "Visit http://127.0.0.1:3000 to use Grafana"
### Get password for user `admin` in Grafana
kubectl get secret --namespace s03-exercise-02 grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
##

## Exposing Kubeapps
export POD_NAME=$(kubectl get pods -n kubeapps -l "app=kubeapps,release=kubeapps" -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward -n kubeapps $POD_NAME 8081:8080
echo "Visit http://127.0.0.1:8081 use Kubeapps Dashboard"
### Get token accessing to Kubeapps
kubectl create serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
kubectl get secret $(kubectl get serviceaccount kubeapps-operator -o jsonpath='{.secrets[].name}') -o jsonpath='{.data.token}' | base64 --decode
##

## If you cannot access via port-forwarding, you can always forward everything via proxy:
kubectl proxy
echo "Visit http://127.0.0.1:8001/api/v1/namespaces/s03-exercise-02/services/kibana:443/proxy/app/kibana to use Kibana"


#################################################################################
######                              LAST PART                               #####
#################################################################################

# Packaging the deps
helm dep build .

# Packaging the chart 
helm package -d '../static/charts/' .

# Creating an index
helm repo index . --url https://<server_public_ip>/charts

# Serving our chart
helm serve --repo-path '.\static\charts\' --address '0.0.0.0:8080'
echo "Visit http://127.0.0.1:8081 to use see your local chart repo"

