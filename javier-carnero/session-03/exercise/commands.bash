#!/bin/bash

helm install ./
RELEASE=$(helm list -q | tail -1)

kubectl cp install-plugins.sh $(kubectl get pods -lapp=$RELEASE-wordpress -ojsonpath="{.items[0].metadata.name}"):/install-plugins.sh

kubectl exec $(kubectl get pods -lapp=$RELEASE-wordpress -o jsonpath="{.items[0].metadata.name}") -- /bin/bash -c "chmod +x /install-plugins.sh && /install-plugins.sh ""$@"

kubectl cp ../../../../k8s-example-wp-plugin/k8s_example_plugin.php $(kubectl get pods -lapp=$RELEASE-wordpress -ojsonpath="{.items[0].metadata.name}"):/opt/bitnami/wordpress/wp-content/plugins/k8s_example_plugin.php