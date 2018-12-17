#!/bin/bash

helm install stable/prometheus --name=prometheus --namespace=monitoring
helm install stable/grafana --name=grafana --namespace=monitoring -f grafana.yaml