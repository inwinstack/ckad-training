kubectl create ns logging

# Install elasticsearch
helm install stable/elasticsearch --namespace logging --name elasticsearch --set master.replicas=2,data.replicas=1,client.replicas=1

# Install fluentd
helm install stable/fluentd-elasticsearch --namespace logging --name fluentd --set elasticsearch.host=elasticsearch-client.logging.svc.cluster.local,elasticsearch.port=9200

# Install kibana
helm install stable/kibana --namespace logging --name kibana --set env.ELASTICSEARCH_URL=http://elasticsearch-client.logging.svc:9200,env.SERVER_BASEPATH=/api/v1/namespaces/logging/services/kibana:443/proxy


http://127.0.0.1:8001/api/v1/namespaces/logging/services/kibana:443/proxy/app/kibana

