# Exercise 2

## MariaDB

### Master

#### Deployment

The following `Deployment` deploys one **master** instance of MariaDB database.
It uses `ConfigMap` and `Secret` to inject the database configuration as
environment variables in the container. Some new environment variables are
required for master-slave configuration, like `MARIADB_REPLICATION_MODE` or
`MARIADB_REPLICATION_USER`.

Notice that the pod has some constraints for CPU and memory consumption

&nbsp;
<details>
<summary>**`mariadb-master.deployment.yaml`**</summary>

<<< @/session-01/exercise-02/mariadb-master.deployment.yaml{31-39,55-61}
</details>

#### Service

A `Service` its also required to make this instance visible on the cluster.
This `Service` is exposing port `3306/TCP`, which is the default port for
MariaDB.

&nbsp;
<details>
<summary>**`mariadb-master.svc.yaml`**</summary>

<<< @/session-01/exercise-02/mariadb-master.svc.yaml
</details>

### Slave

#### Deployment

There are two slave instances in this `Deployment`.

Also, notice that `maxUnavailable` has been added to the rolling update
strategy to ensure at least 40% of the instances are .

&nbsp;
<details>
<summary>**`mariadb-slave.deployment.yaml`**</summary>

<<< @/session-01/exercise-02/mariadb-slave.deployment.yaml{14}
</details>

#### Service

&nbsp;
<details>
<summary>**`mariadb-slave.svc.yaml`**</summary>

<<< @/session-01/exercise-02/mariadb-master.svc.yaml
</details>

## Wordpress

### Deployment

There is one `Deployment` for Wordpress. The main difference with the exercise 1
is that there are some resources constrains to ensure optimal performance.

&nbsp;
<details>
<summary>**`wordpress.deployment.yaml`**</summary>

<<< @/session-01/exercise-02/wordpress.deployment.yaml{43-62}
</details>

### Service

&nbsp;
<details>
<summary>**`wordpress.svc.yaml`**</summary>

<<< @/session-01/exercise-02/wordpress.svc.yaml
</details>

### HyperDB

Wordpress does not balance database connection out of the box. If balancing
connections is a requirement, HyperDB is the way to go. HyperDB allows us to
set multiple database instances so Wordpress can balance connections and
improve performance.

## ConfigMap and Secrets

This `ConfigMap` is the same as the previous exercise.

&nbsp;
<details>
<summary>**`database.cm.yaml`**</summary>

<<< @/session-01/exercise-02/database.cm.yaml
</details>


The `Secret` has one more key `repl-password`.

```bash
$ kubectl create secret generic database-secrets \
    --from-literal=root-password=ultrasecretpassword \
    --from-literal=repl-password=ultrasecretpassword
```
