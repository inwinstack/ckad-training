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

Two different deployments have been created, master and slave. The main differences are the set of environment variables and the number of initial replicas.
Due to a bug in the latest bitnami/mariadb image related to the proper configuration of the env vars, the version has been downgraded to `10.1.21-r2`.

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

This WP plugin is slightly different since it is not installed from the UI. The plugin, [downloadable here](https://downloads.wordpress.org/plugin/hyperdb.1.5.zip), is composed of two files: the configuration file `db-config.php` and the core file `db.php`.
The installation steps are as follows:

1. Enter the proper configuration in `db-config.php`
2. Copt `db-config.php` in the directory that holds `wp-config.php`.
3. Copy `db.php` to the `/wp-content/` directory.

In this scneario, the important excerpt of the `db-config.php` file are:
```
// Add master database for writing (we use PHP variables since thay have previously loaded from the env vars)
$wpdb->add_database(array(
    'host'     => DB_HOST, //"mariadb-master" 
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 1, // write: enabled
    'read'     => 0, // read: disabled
    'dataset'  => 'global',
    'timeout'  => 0.2,
));
```
```
// Add slave database pool for reading
$wpdb->add_database(array(
    'host'     => "mariadb-slave", //the interally exposed name in the kubedns
    'user'     => DB_USER,
    'password' => DB_PASSWORD,
    'name'     => DB_NAME,
    'write'    => 0,  // write: disabled
    'read'     => 1,  // read: enabled
    'dataset'  => 'global',
    'timeout'  => 0.2,
));
```

## Technical debt
  
This scenario is *absolutely* not ready for production purposes. Specifically, there remain two major issues to be addressed:

1) **Expose the service in a common 80 port**. Two alternatives here: 
    1.1) Use **LoadBalancer** service: in order to use a LoadBalancer in AWS, we should move to an EKS cluster for that, or install the AWS addon that allows you to create ELBs on demand.
    1.1) Use an **Ingress** controller: we have to install the Ingress addon into the cluster (e.g. nginx or HAProxy) and create the rules to forward the traffic

2) **Configure SSL/TLS to secure the http traffic**. A straightforward way to do that is to generate a Let'sEncrypt free certificate and configure it in either the WordPress or the ingress service.

3) **Add persistence** by configuring NFS/EBS/... storage and creating PVCs.

4) **Consider using StatefulSet** when adding persistence to nodes. This object deals with a distributed application that requires each node to have a persistent state and the ability to configure an arbitrary number of nodes through a configuration


