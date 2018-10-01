# Deliverable antonio_gamez/session-01/exercise-02
---

## Main goals
  
* All the resources should be created under the *exercise-02* namespace.

* The WP site should use a MariaDB database.

* MariaDB should be configured with replication with a master-slave model. There should be 1 master and 2 slaves.

* Use ConfigMaps and Secrets to configure both MariaDB and WP.

* Every pod should configure the CPU/RAM requested to the cluster, and the limits for them.

* Every container should have the proper readiness and liveness probes configured.

* Wordpress should be publicly available while MariaDB should only be accessible internally (you can consider your cluster supports LoadBalancer service type.

* Ensure there won't be more than 40% or the replicas unavailable when running rolling updates on slave deployment. You can document how to do it or include the steps in the commands.bash* file.

* Scale slaves to 5 replicas. You can document how to do it or include the steps in the *commands.bash* file.

* Document the steps to follow to install HyperDB WP plugin and configure it to balance SQL request between Master&Slaves services.

  
## Steps to set up this scenario

1) From this directory, run `kubectl create -f ./resources` or exec the `./commands.sh` script.
2) Open in a browser:  http://18.213.63.179:31080 or  https://18.213.63.179:31443.
3) Enjoy your new k8s-flavored Wordpress :)

## Remarks about the proposed solution

Discussion about some non-trivial aspects (not covered in exercise01) of the solution and the expected goals:

> MariaDB should be configured with replication with a master-slave model. There should be 1 master and 2 slaves.

**TBD** **TBD** **TBD**

> Every pod should configure the CPU/RAM requested to the cluster, and the limits for them.

Inside each deployment file, at level .spec.containers[...] simply add a similar block as follows:
```
        resources:
            requests:
              memory: "256m"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
```
> Ensure there won't be more than 40% or the replicas unavailable when running rolling updates on slave deployment.

Inside each deployment file, inside .spec.strategy simply add a similar block as follows:
```
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 40%
      maxSurge: 50%
```

> Scale slaves to 5 replicas. You can document how to do it or include the steps in the *commands.bash* file.

It is achieved simply typing `kubectl scale -l "app=wordpress,tier=database,mode=slave" --replicas=5`. A best approach to do scaling up/down is to define an Horizontal Pod Autoscaler from some default (or even custom) metrics. A simple autoscaler could be `kubectl autoscale -l "app=wordpress,tier=database,mode=slave" --min=2 --max=5 --cpu-percent=80`

> Document the steps to follow to install HyperDB WP plugin and configure it to balance SQL request between Master&Slaves services.

**TBD** **TBD** **TBD**

---



la cosa esta se instala desde https://downloads.wordpress.org/plugin/hyperdb.1.5.zip

1. Enter a configuration in `db-config.php`.

2. Deploy `db-config.php` in the directory that holds `wp-config.php`. This may be the WordPress root or one level above. It may also be anywhere else the web server can see it; in this case, define `DB_CONFIG_FILE` in `wp-config.php`.

3. Deploy `db.php` to the `/wp-content/` directory. Simply placing this file activates it. To deactivate it, move it from that location or move the config file.



$wpdb->add_database(array(
    'host'     => DB_HOST, //"mariadb-master"    // If port is other than 3306, use host:port.
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 1,
    'read'     => 0,
    'dataset'  => 'global',
    'timeout'  => 0.2,
));

$wpdb->add_database(array(
    'host'     => "mariadb-slave",     // If port is other than 3306, use host:port.
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 0,
    'read'     => 1,
    'dataset'  => 'global',
    'timeout'  => 0.2,
));



Use 'StatefulSet' with a distributed application that requires each node to have a persistent state and the ability to configure an arbitrary number of nodes through a configuration (replicas = 'X'). seria una mejor opcion, pero no usamos todas esas cosas aun en este eeciccio

$wpdb->add_database(array(
    'host'     => DB_HOST, //"mariadb-master"    // If port is other than 3306, use host:port.
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 1,
    'read'     => 0,
    'dataset'  => 'global',
    'timeout'  => 0.2,
));

$wpdb->add_database(array(
    'host'     => "mariadb-slave",     // If port is other than 3306, use host:port.
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 0,
    'read'     => 1,
    'dataset'  => 'global',
    'timeout'  => 0.2,
));

All nodes in a master-master configuration and slave nodes in a master-slave configuration can make use of a StatefulSet along with a Service. Master nodes (like master, master-secondary) may each be a Pod with some persistent volume along with a Service as these nodes have no need to scale up or down. They can as well be a StatefulSet with replicas = 1.

Examples of StatefulSet are: 
- Datanodes (slaves) in a Hadoop cluster (master-slave) 
- Database nodes (master-master) in a Cassandra cluster

Each Pod (replica) in a StatefulSet has 
- A unique and stable network identity 
- Kubernetes creates one PersistentVolume for each VolumeClaimTemplate 
https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

'Deployment' on the other hand is suitable for stateless applications/services where the nodes do not require any special identity (a load balancer can reach any node that it chooses) and the number of nodes can be an arbitrary number.




---

## Technical debt
  
This scenario is *absolutely* not ready for production purposes. Specifically, there remain two major issues to be addressed:

1) **Expose the service in a common 80 port**. Two alternatives here: 
    1.1) Use **LoadBalancer** service: in order to use a LoadBalancer in AWS, we should move to an EKS cluster for that, or install the AWS addon that allows you to create ELBs on demand.
    1.1) Use an **Ingress** controller: we have to install the Ingress addon into the cluster (e.g. nginx or HAProxy) and create the rules to forward the traffic

2) **Configure SSL/TLS to secure the http traffic**. A straightforward way to do that is to generate a Let'sEncrypt free certificate and configure it in either the WordPress or the ingress service.

