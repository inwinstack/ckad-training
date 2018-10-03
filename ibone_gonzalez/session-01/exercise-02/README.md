# Exercise II

## First steps

We are going to create a namespace "exercise01" for the exercise and so everything is in it.

```
kubectl create ns exercise02
```

En este caso los secrets se van a crear por siguientes comandos

```
kubectl create secret generic mariadb --from-literal=password=root --namespace=exercise02
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise02
kubectl create secret generic mariadb-pass-replication-user --from-literal=password=user --namespace=exercise02
```

I also used a config map for the development of the exercise

```
kubectl create -f cm.yaml
```

## Wordpress + MariaDB (master-slave)

In this exercise we have made the documents and commands necessary to perform the deployment of a WP + MariaDB.

The files required for this part of the exercise are:

- mariadb-master-deployment.yaml
- mariadb-master-svc.yaml
- mariadb-slave-deployment.yaml
- mariadb-slave-svc.yaml
- wordpress-deployment.yaml
- wordpress-svc.yaml

### Add to wordpress HyperDB WP

When I deploy wordpress I run a kubectl exec -ti "pod name" and inside I make the changes that appear in the installation:

" HyperDB:

Nothing goes in the plugins directory.

1. Enter a configuration in `db-config.php`.

2. Deploy `db-config.php` in the directory that holds `wp-config.php`. This may be the WordPress root or one level above. It may also be anywhere else the web server can see it; in this case, define `DB_CONFIG_FILE` in `wp-config.php`.

3. Deploy `db.php` to the `/wp-content/` directory. Simply placing this file activates it. To deactivate it, move it from that location or move the config file."
