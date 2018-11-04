helm install stable/prometheus --name=prometheus --namespace=monitoring
helm install stable/grafana --name=grafana --namespace=monitoring 

kubectl --namespace monitoring port-forward svc/prometheus-server 9090:80 &
kubectl --namespace monitoring port-forward svc/grafana 3000:80 &
