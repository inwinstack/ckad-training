
Click [here](https://github.com/bitnami-labs/ckad-training/blob/master/README.md) for the README original :-)

# Exercise II

## WP + MariaDB with replication

Create the K8s resources you need to deploy a WP site on your K8s cluster using
a MariaDB cluster as database with the characteristics below:

* All the resources should be created under the *exercise-02* namespace.
* The WP site should use a MariaDB database
* MariaDB should be configured with replication with a master-slave model. There
should be 1 master and 2 slaves
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* Every pod should configure the CPU/RAM requested to the cluster, and the limits
for them.
* Every container should have the proper readiness and liveness probes
configured
* Wordpress should be publicly available while MariaDB should only be accessible
internally (you can consider your cluster supports LoadBalancer service type)

Once everything is setup:

* Ensure there won't be more than 40% or the replicas unavailable when running
rolling updates on slave deployment. You can document how to do it or include the
steps in the *commands.bash* file.
* Scale slaves to 5 replicas. You can document how to do it or include the steps
in the *commands.bash* file.
* Document the steps to follow to install HyperDB WP plugin and configure it to
balance SQL request between Master&Slaves services

## Steps

### Give execution permission to the files and execute it:

```
chmod u+x commands.bash installer_hyperdb.sh
```

### Deploy the infrastructure:

```
./commands.bash
```

### Ensure there won't be more than 40% or the replicas unavailable when running rolling updates on slave deployment:

For this, add the next code to spec section:
```
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 40%
```

### To scale the number of pods for the slave deployment, execute the following instruction:

```
kubectl scale deployment -n exercise-02  mariadb-slave --replicas=5
```
**Note:** Wait until the infrastructure is fully deployed, to execute it

### Install HyperDB WP plugin

Just execute the script called "installer_hyperdb.sh"
```
./installer_hyperdb.sh
```

### Notes

Docs about how to manager resources on pods:

https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/

Interesting links to consult when configuring HyperDB:

https://wordpress.org/plugins/hyperdb/
https://www.digitalocean.com/community/tutorials/how-to-optimize-wordpress-performance-with-mysql-replication-on-ubuntu-14-04
