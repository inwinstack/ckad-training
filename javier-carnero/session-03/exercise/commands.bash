#!/bin/bash

helm install ./
RELEASE=$(helm list -q | tail -1)

kubectl cp install-plugins.sh $(kubectl get pods -lapp=$RELEASE-wordpress -ojsonpath="{.items[0].metadata.name}"):/install-plugins.sh

kubectl exec $(kubectl get pods -lapp=$RELEASE-wordpress -o jsonpath="{.items[0].metadata.name}") -- /bin/bash -c "chmod +x /install-plugins.sh && /install-plugins.sh ""$@"