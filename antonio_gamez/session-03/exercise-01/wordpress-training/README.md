# WordPress

[WordPress](https://wordpress.org/) is one of the most versatile open source content management systems on the market. A publishing platform for building blogs and websites.

## Disclaimer: 

This README has been copied and tweaked a little from the [official Wordpress chart from Bitnami](https://github.com/helm/charts/tree/master/stable/wordpress) in the context of a k8s training. Therefore, this chart is absolutely **not intended to be production-ready**.

## TL;DR;

```console
$ helm install stable/wordpress
```

## Introduction

This chart bootstraps a [WordPress](https://github.com/bitnami/bitnami-docker-wordpress) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

It packages the [Bitnami MariaDB chart](https://github.com/kubernetes/charts/tree/master/stable/mariadb) which is required for bootstrapping a MariaDB deployment for the database requirements of the WordPress application.

It also packages the [Bitnami MySQL chart](https://github.com/kubernetes/charts/tree/master/stable/mysql) which is required for bootstrapping a MySQL deployment for the database requirements of the WordPress application.

Bitnami charts and, in particular, can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Features

As requested, this chart is able to do the following:

* Setting the number of WordPress replicas
* Ingress (with TLS Support)
* NetworkPolicies
* Persistence
* Choosing between MySQL or MariaDB as the backend
* MySQL dump backup CronJob
* Providing a set of plugins to install at deployment time
* Have a builtin WP plugin working with RBAC: https://github.com/javsalgar/k8s-example-wp-plugin 

## Prerequisites

- Kubernetes 1.4+ with Beta APIs enabled
- A deployment of the `cert-manager` chart into the cluster
- PV provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release stable/wordpress
```

The command deploys WordPress on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the WordPress chart and example values. 


|            Parameter             |                Description                 |                         Example                         |
|----------------------------------|--------------------------------------------|---------------------------------------------------------|
| `image.registry` | | `docker.io` |
| `image.repository` | | `bitnami/wordpress` |
| `image.tag` | | `4.9.8-debian-9-r51` |
| `image.pullPolicy` | | `IfNotPresent` |
| `certManager.enabled` | | `true` |
| `certManager.email` | | `someone@example.com` |
| `certManager.acmeServer` | | `https://acme-v02.api.letsencrypt.org/directory` |
| `certManager.commonName` | | `k8s.governify.io` |
| `certManager.dnsNames` | | [k8s.governify.io, www.k8s.governify.io] |
| `netpol.enabled` | Enable a NetworkPolicy between WP and database | `true` |
| `dbDump.enabled` | | `true` |
| `dbDump.dbuser` | | `root` |
| `dbDump.dbpass` | | `root_password` |
| `dbDump.dbhost` | | `mariadb` |
| `dbDump.all_databases` | | `true` |
| `dbDump.everyMinutes` | | `10` |
| `wordpressInfo.blogName` | | ` K8S training` |
| `wordpressInfo.username` | | `someone` |
| `wordpressInfo.email` | | `someone@example.com` |
| `wordpressInfo.firstName` | | `John` |
| `wordpressInfo.lastName` | | `Doe` |
| `wordpressConfig.databaseName` | | `database_wp` |
| `wordpressConfig.databaseUser` | | `dbuser_wp` |
| `wordpressConfig.databasePassword` | | `dbuser_password` |
| `wordpressConfig.dbRootUser` | | `root` |
| `wordpressConfig.dbRootPassword` | | `root_password` |
| `wordpressConfig.wpUser` | | `someone` |
| `wordpressConfig.wpPassword` | | `someone_wp` |
| `wordpressConfig.replicaCount` | | `1` |
| `wordpressConfig.preinstalledPlugins` | List of plugin:version to be installed automatically | `[dark-mode.3.1,jetpack.6.6.1,...]` |
| `wordpressConfig.metricsExporter.enabled` | Install a Prometheus metrics exporter for WP  | `true` |
| `namespace` | Namespace where the chart will be deployed (needed for RBAC) | `default` |
| `nodePorts.http` | | `31080` |
| `nodePorts.https` | | `31443` |
| `healthcheckHttps` | | `false` |
| `livenessProbe` | | livenessProbe k8s object |
| `readinessProbe` | | readinessProbe k8s object |
| `persistence` | | persistence k8s object |
| `resources.requests.memory` | | `512Mi` |
| `resources.requests.cpu` | | `300m` |
| `ingress.enabled` | | `true` |
| `ingress.hosts[0].name` | | `k8s.governify.io` |
| `ingress.hosts[0].tls` | | `true` |
| `ingress.hosts[0].annotations` | | ingress anotations |
| `mariadb.enabled` | | `false` |
| `mariadb.replication.enabled` | | `false` |
| `mariadb.db.name` | | `database_wp` |
| `mariadb.db.user` | | `dbuser_wp` |
| `mariadb.db.password` | | `dbuser_password` |
| `mariadb.master.persistence.enabled` | | `true` |
| `mariadb.master.persistence.accessMode` | | `ReadWriteOnce` |
| `mariadb.master.persistence.size` | | `8Gi` |
| `mariadb.rootUser.user` | | `root` |
| `mariadb.rootUser.password` | | `root_password` |
| `mysql.enabled` | | `false` |
| `mysql.replication.enabled` | | `false` |
| `mysql.master.persistence.enabled` | | `true` |
| `mysql.master.persistence.accessMode` | | `ReadWriteOnce` |
| `mysql.master.persistence.size` | | `8Gi` |
| `mysql.mysqlDatabase` | | `xxdatabase_wpxx` |
| `mysql.mysqlUser` | | `dbuser_wp` |
| `mysql.mysqlPassword` | | `dbuser_password` |
| `mysql.mysqlRootPassword` | | `root_password` |


The above parameters map to the env variables defined in [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress). For more information please refer to the [bitnami/wordpress](http://github.com/bitnami/bitnami-docker-wordpress) image documentation.

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
$ helm install --name my-release \
  --set wordpressUsername=admin,wordpressPassword=password,mariadb.mariadbRootPassword=secretpassword \
    stable/wordpress
```

The above command sets the WordPress administrator account username and password to `admin` and `password` respectively. Additionally, it sets the MariaDB `root` user password to `secretpassword`.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
$ helm install --name my-release -f values.yaml stable/wordpress
```

> **Tip**: You can use the default [values.yaml](values.yaml)


## Persistence

The [Bitnami WordPress](https://github.com/bitnami/bitnami-docker-wordpress) image stores the WordPress data and configurations at the `/bitnami` path of the container.

## Ingress

This chart provides support for ingress resources. If you have an
ingress controller installed on your cluster, such as [nginx-ingress](https://kubeapps.com/charts/stable/nginx-ingress) you can utilize
the ingress controller to serve your WordPress application.

To enable ingress integration, please set `ingress.enabled` to `true`

### Hosts

Most likely you will only want to have one hostname that maps to this
WordPress installation, however, it is possible to have more than one
host.  To facilitate this, the `ingress.hosts` object is an array.

For each item, please indicate a `name`, `tls`, `tlsSecret`, and any
`annotations` that you may want the ingress controller to know about.

Indicating TLS will cause WordPress to generate HTTPS URLs, and
WordPress will be connected to at port 443.  The actual secret that
`tlsSecret` references do not have to be generated by this chart.
However, please note that if TLS is enabled, the ingress record will not
work until this secret exists.

For annotations, please see [this document](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md).
Not all annotations are supported by all ingress controllers, but this
document does a good job of indicating which annotation is supported by
many popular ingress controllers.

### TLS Secrets

This chart will facilitate the creation of TLS secrets for use with the
ingress controller with an additional tool (like [cert-manager](https://kubeapps.com/charts/stable/cert-manager))
manages the secrets for the application

If you are going to use Helm to manage the certificates, please copy
these values into the `certificate` and `key` values for a given
`ingress.secrets` entry.