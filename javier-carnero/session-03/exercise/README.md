# S03 Exercise

Wordpress chart with some custom features, and with logging and monitoring capabilities enabled

## What's implemented

* _Part 1_: The chart allows setting:
    * The number of replicas (from base chart)
    * Ingress with TLS support (from base chart)
    * NetworkPolicies for database
    * Persistence (mariadb from base chart)
    * Choose MySQL or MariaDB as database backend
    * Database backup CronJob
* _Part 2_: The chart installs WP-CLI using a hook, and then install the list of plugins defined at `values.yaml`. The plugins can also be automatically activated if configured in the same file.
* _Part 3_: The chart installs the awesome Salme's plugin and activates it using a hook. A helper container makes a proxy with the K8s API.
* _Part 4_: A helper container prints the error logs to stdout. `logging/install.sh` deploys EFK on the k8s sandbox. WARN: t2.large instance is needed.
* _Part 5_: Using a hook, the chart installs an exporter as a plugin. This 'plugin' is activated automatically, and the pod annotated to be scraped. Grafana sets automatically prometheus as its default datasorce, and creates a simple wordpress dashboard.
* _Part 6_: TODO: Create a repository for the wordpress chart. Then install Kubeapps and add the repository to it.
