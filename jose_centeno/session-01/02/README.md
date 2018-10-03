# Solution for Exercise II (not finished)

## WP + MariaDB with replication

Create the K8s resources you need to deploy a WP site on your K8s cluster using
a MariaDB cluster as database with the characteristics below:

* All the resources should be created under the *exercise-02* namespace.

This will be the first step. Creating all the resources under a specific namespace
avoids errors due to interference between different scenarios

* The WP site should use a MariaDB database. MariaDB should be configured with
replication with a master-slave model. There should be 1 master and 2 slaves

It will be needed 3 deployments (wordpress, mariaDB-master, mariaDB-slaves) so
they could be scaled separately

* Use ConfigMaps and Secrets to configure both MariaDB and WP

The pods will be configured to use all the values on the configmap / secret.

* Every pod should configure the CPU/RAM requested to the cluster, and the limits
for them.

It didn't work for me, and I had no time to check :-(

* Every container should have the proper readiness and liveness probes
configured

Readiness and liveness probes will be to check if a TCP connection can be 
established on the service port (3306 mariadb, 80 wordpress).

* Wordpress should be publicly available while MariaDB should only be accessible
internally (you can consider your cluster supports LoadBalancer service type)

Mariadb will use a ClusterIP service while wordpress will use a LoadBalancer. The
loadBalancer will have the same behaviour than a NodePort because can't get a 
public IP.


* Ensure there won't be more than 40% or the replicas unavailable when running
rolling updates on slave deployment. You can document how to do it or include the
steps in the *commands.bash* file.
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-update-deployment

From the doc, configure the pod (on deployment) with:
.spec.strategy.type==RollingUpdate
.spec.strategy.rollingUpdate.maxUnavailable=40%

* Scale slaves to 5 replicas. You can document how to do it or include the steps
in the *commands.bash* file.

kubectl scale deployment myblog-mariadb-slave --replicas=5

* Document the steps to follow to install HyperDB WP plugin and configure it to
balance SQL request between Master&Slaves services

I've created a new docker image (wordpress directory) based on bitnami/wordpress:latest. This
image add all the configuration files that are needed.
This image has to be available from the EC2 instance, I have ssh the instance, copy wordpress
directory and build the image with: sudo docker build --tag jica/wordpress:hyperDB . 
Now, you can use wordpress-hyperDB-deployment.yaml to create the wordpress deployment. Also, it
is possible to update the image from kubectl

### Tips

* Use a linter to avoid syntax errors on your YAML/JSON files
* RollingUpdate Strategy: `kubectl explain deploy.spec.strategy`

### Notes

Docs about how to manager resources on pods:

https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/

Interesting links to consult when configuring HyperDB:

https://wordpress.org/plugins/hyperdb/
https://www.digitalocean.com/community/tutorials/how-to-optimize-wordpress-performance-with-mysql-replication-on-ubuntu-14-04
