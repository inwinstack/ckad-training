

CKAD Bitnami K8s Training user: pablo_lara
---

# Session III: WordPress Chart

### Part I: Create a chart that it must allow setting:
- Setting the number of WordPress replicas
- Ingress (with TLS Support)
- Network Policies
- Persistence
- Choosing between MySQL or MariaDB as the backend
- MySQL dump backup CronJob

### Part II: More features to the chart:
- Providing a set of plugins to install at deployment time

### Part III: Let's play with RBAC
- Implement k8s-example-wp-plugin that requires RBAC

### Part IV: Let's play with logging
- Implement a helper container to see the error log in Kibana

### Part V: Let's play with metrics
- Add an option to the chart to enable the metrics
- With the metrics, create a simple Grafana dashboard

### Part VI: Now that you have the Chart
- Create a repository with your created chart and add it to Kubeapps
