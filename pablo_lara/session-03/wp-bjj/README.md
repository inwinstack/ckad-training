CKAD Bitnami K8s Training user: pablo_lara
---
# Session III: WordPress Chart

***The exercise is not complete***
### Part I: Create a chart that it must allow setting:
The next setup is implemented in *values.yaml*
- Setting the number of WordPress replicas:
~~~
replicaCount: 1
~~~
- Ingress (with TLS Support):
~~~
ingress:
  enabled: true
  hosts:
  - name: myblog.com
    tls: true
    annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/ssl-redirect: "true"
~~~
- Network Policies:
~~~
networkpolicies:
  enable: true
~~~
- Persistence:
~~~
persistence:
  enabled: true
  accessMode: ReadWriteOnce
  size: 10Gi
~~~
- Choosing between MySQL or MariaDB as the backend:
~~~
########
mariadb:
  enabled: true
  replication:
    enabled: false
  db:
    name: bitnami_wordpress
    user: bn_wordpress
    password: bitnami
  master:
    persistence:
      enabled: true
      accessMode: ReadWriteOnce
      size: 5Gi
########
mysql:
  enabled: false
  replication:
    enabled: false
  master:
    persistence:
      enabled: true
      accessMode: ReadWriteOnce
########
~~~
- MySQL dump backup CronJob:
~~~
mysqldump:
  enabled: true
  everyMinutes: 60
  persistence:
    enabled: true
    accessMode: ReadWriteOnce
    size: 5Gi
~~~

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
