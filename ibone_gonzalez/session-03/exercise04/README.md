# Logging

Source
https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch tweaked for:

- all: deploy to logging namespace
- elasticsearch: adjust limits.cpu down, to better fix single VM Bitnami Kubernetes Sandbox
- fluentd-elasticsearch: remove spec.nodeSelector

Diffs from upstream have been saved to ./kubernetes_cluster_addons_fluentd-elasticsearch.diff.

For the access go to: http://localhost:8001/api/v1/namespaces/logging/services/kibana-logging/
