# Exercise I

## Álvaro Martín Rodríguez
## Wordpress + MariaDB. Using canary for WP.

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

mariadb is created as a **deployment** without replication, adding two
_labels_ that refer to the _app_ (mariadb) and the app it serves indirectly
(wordpress).

The **containers** are created with the specification of the:
- Root password
- DB name it should create
- DB user it should create
- DB user password it should attach to the previous user

This data is obtained from _configMap_ and _secret_ previously created.

To this, we add **probes** of _readiness_ and _liveness_ configured with
different values based on their use. We use _tcp_ probes to test db availability.

The _pods_ are exposed through a **service** (_ClusterIP_) which allows other
resources inside the cluster to access them.

#### WordPress

WordPress is created as a **deployment** with replication set to one, adding
the same _labels_ that we used in mariadb deployment, plus a new one that
allows us to difference between this deployment (_stable_) and the _canary_.

Therefore, another **deployment** is created for the _canary_ with all similar
except this _label_, and the _wordpress image version_.

The **containers** are created with the data:
- Database name
- Database user
- Database user password

As we did with _mariadb_, this data is obtained from _configMap_ and _secret_
previously created.

To this, we add **probes** of _readiness_ and _liveness_ configured with
different values based on their use. We use _http_ probes to test wp availability.

The _pods_ are exposed through a **service** (_LoadBalancer_) which allows
access from outside the cluster plus a load balance, as it names indicates.
Problem comes from the non availability of static IP for this service, which
therefore never starts.
We've created a second **service** (_NodePort_) in order to be able to access to
our WordPress from outside the cluster.

Finally, this **service** is the one we've modified to ensure _Session Affinity_,
which means the same client request will be directed to the same pod until
the session times out.
