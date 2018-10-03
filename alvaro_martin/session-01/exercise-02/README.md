# Exercise II

## Álvaro Martín Rodríguez
## Wordpress + MariaDB. Master-Slave MariaDB will be used.

### Files structure

Based on the given templates, I've added **ConfigMap files** for both applications
wordpress and mariadb. **Secrets** had been created using files as well, stored
in their respective file for each application.

Finally, **commands.sh** contains the bash commands that I've used to deploy it
all. It contains previous versions of commands that were _discarded_ but kept as
_comments_, plus _debug commands_ commented as well. At the end of the file,
there're are different commands to _delete the resources_, but they're
commented too because of the use of the script to deploy the complete
environment.

### Environment explanation

#### mariadb

mariadb is created as two **deployments**, adding three
_labels_ that refer to the _app_ (mariadb), the app it serves indirectly
(wordpress) and its _role_ (master or slave).

_master_ is specified with just 1 replica but _slave_ is configured with 2.

_both_ have revision limit set to 3, and strategy type set as _rolling update_.

The **containers** are created with the specification of:

+ For the master database:
- Root password
- DB name it should create
- DB user it should create
- DB user password it should attach to the previous user
- Replication mode (set to _master_)
- Replication user
- Replication password

+ For the slave database:
- Replication mode (set to _slave_)
- Replication user
- Replication password
- Mariadb _master_ host
- Mariadb _master_ root password

This data is obtained from _configMap_ and _secret_ previously created.

To this, we add **probes** of _readiness_ and _liveness_ configured with
different values based on their use. We use _tcp_ probes to test db availability.

This time we've added **resource control** as well. After some
research we've choose values from examples with similar apps. Limits
were set to the double of the minimun requested amount.

The _pods_ are exposed through two **services** (_ClusterIP_) which allows other
resources inside the cluster to access them. Each service targets
only the master or slave pods, so we can do load balance just asking for one of
these two services each time (i.e).

#### WordPress

WordPress is created as a **deployment** with replication set to one, adding
the same _labels_ that we used in mariadb deployment, except the one
for the _role_.

It has revision limit set to 3, and strategy type set as _rolling update_.

The **containers** are created with the data:
- Database name
- Database user
- Database user password
- Database hostname: set to _mariadb-master_. This one would be changed/bypassed after
using the suggested plugin.

As we did with _mariadb_, this data is obtained from _configMap_ and _secret_
previously created.

To this, we add **probes** of _readiness_ and _liveness_ configured with
different values based on their use. We use _http_ probes to test wp availability.

This time we've added **resource control** as well. Values have been chosen
with the same idea behind mariadb values.

This time we created a **service** (_NodePort_) in order to be able to access to
our WordPress from outside the cluster, since _LoadBalancer_ can't be used by us.