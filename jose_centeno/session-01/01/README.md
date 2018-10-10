# Solution for Exercise I

## WP + MariaDB with Canary

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace

The first step will be create the namespace exercise-01

The WP site should use a MariaDB database

It will be needed 2 deployments, one for each application

* Use ConfigMaps and Secrets to configure both MariaDB and WP

The pods will be configured to use all the values on the configmap / secret.
It could be possible to create a cm / secret for each deployment, but I think
that this way will be more clear.

* Every container should have the proper readiness and liveness probes
configured

Readiness and liveness probes will be to check if a TCP connection can be 
established on the service port (3306 mariadb, 80 wordpress).

* Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP
version and use 4.9.8 in the canary deployment

Canary deployment will be equal to wordpress deployment but with a different
label (only one of them).

* Wordpress should be publicly available while MariaDB should only be accessible
internally (you can consider your cluster supports LoadBalancer service type)

Mariadb will use a ClusterIP service while wordpress will use a LoadBalancer. The
loadBalancer will have the same behaviour than a NodePort because can't get a 
public IP.

* You need to guarantee Session Affinity when using Canary Deployments. See https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-ipvs

It is also necesary when creating more than one wordpress pod, because sessions
are not shared between wordpress servers.


## Used References
# https://github.com/bitnami/bitnami-docker-wordpress
# https://hub.docker.com/r/bitnami/mariadb/
