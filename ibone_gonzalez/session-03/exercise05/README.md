# Metrics

For install grafana and prometheus:

`helm install stable/prometheus --name=prometheus --namespace=monitoring`
`helm install stable/grafana --name=grafana --namespace=monitoring`

For access in the browser:

`kubectl --namespace monitoring port-forward svc/prometheus-server 9090:80 &`

`kubectl --namespace monitoring port-forward svc/grafana 3000:80 &`

The user of grafana is user and to get password of grafana:

`grafana_secret=$(kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)`
`echo ${grafana_secret:?}`

To connect the data source:
