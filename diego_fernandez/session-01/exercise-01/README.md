# Exercise 1

## MariaDB

The following `Deployment` deploys one instance of MariaDB database. It uses
`ConfigMap` and `Secret` to inject the database configuration as environment
variables in the container.

&nbsp;
<details>
<summary>**`mariadb.deployment.yaml`**</summary>

<<< @/session-01/exercise-01/mariadb.deployment.yaml{27-42}
</details>

A `Service` its also required to make this instance visible inside the
cluster. This `Service` is exposing port `3306/TCP`, which is the default port
for MariaDB.

&nbsp;
<details>
<summary>**`mariadb.svc.yaml`**</summary>

<<< @/session-01/exercise-01/mariadb.svc.yaml{8-11}
</details>

## Wordpress

There is two `Deployments` for Wordpress: **stable** and **canary**. The main
difference between them is that the canary `Deployment` uses a more recent
version. Both `Deployments` are using `ConfigMap` for injecting configuration to the
container and `Secret` to keep the sensitive information private.

Stable `Deployment` has the **stable** tag, meanwhile
the canary `Deployment` has the **canary** tag.

There is also a **liveness probe** which checks every 30 seconds if the app is
listen on the port 80.

### Canary Deployment

&nbsp;
<details>
<summary>**`wordpress-canary.deployment.yaml`**</summary>

<<< @/session-01/exercise-01/wordpress-canary.deployment.yaml{17-19,43-55}
</details>

### Stable Deployment

&nbsp;
<details>
<summary>**`wordpress.deployment.yaml`**</summary>

<<< @/session-01/exercise-01/wordpress.deployment.yaml
</details>

### Service

There is a single service for exposing both `Deployments` so incoming requests
are routed to both `Deployment`.

Since Wordpress instances are not aware of anothers
instances, the session data is not shared between them, so the `Service`
has to ensure that every client is always routed to the same instance.
To address this problem, the `Service` should guarantee session affinity.

&nbsp;
<details>
<summary>**`wordpress.svc.yaml`**</summary>

<<< @/session-01/exercise-01/wordpress.svc.yaml{8}
</details>

## ConfigMap and Secrets

The following `ConfigMap` is used for store database config. Changing the user
or database name will update both MariaDB and Wordpress. This allow us to change
the configuration in just one place.

&nbsp;
<details>
<summary>**`cm.yaml`**</summary>

<<< @/session-01/exercise-01/cm.yaml
</details>

For sensitive information like passwords a `Secret` object is used. Instead of
creating a YAML file, a command is used to create the `Secret`:

```bash
$ kubectl create secret generic database-secrets \
    --from-literal=root-password=ultrasecretpassword
```
