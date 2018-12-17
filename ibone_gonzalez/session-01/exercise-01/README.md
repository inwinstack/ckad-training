# Exercise I

## First steps

We are going to create a namespace "exercise01" for the exercise and so everything is in it.

```
kubectl create ns exercise01
```

For the creation of the secrets will be done with the following commands:

```
kubectl create secret generic mariadb --from-literal=password=root --namespace=exercise01
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise01
```

I also used a config map for the development of the exercise

```
kubectl create -f cm.yaml
```

## Wordpress + MariaDB

In this exercise we have made the documents and commands necessary to perform the deployment of a WP + MariaDB.

The files required for this part of the exercise are:

- mariadb-deployment.yaml
- mariadb-svc.yaml
- wordpress-deployment.yaml
- wordpress-svc.yaml

## Wordpress canary + MariaDB

In addition, a Canary deployment type has been added which is used to check the operation of new versions or functionalities.

In this case we would only add the canary file:

- wordpress-canary-deployment.yaml

## Finish

When we finish working with this part just delete this namespsace.

```
kubectl delete ns exercise01
```
