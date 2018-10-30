#/bin/bash

kubectl create ns logging
kubectl apply -f es-service.yaml,fluentd-es-configmap.yaml,kibana-service.yaml
kubectl apply -f es-statefulset.yaml,fluentd-es-ds.yaml,kibana-deployment.yaml
