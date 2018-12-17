# Exercise 01

## First steps

The same database has been used for both Drupal and Wordpress.

It is necessary to execute the following commands:

### create namespace

kubectl create ns exercise01

### create secret

kubectl create secret generic mariadb-password --from-literal=password=root --namespace=exercise01
kubectl create secret generic mariadb-pass-user --from-literal=password=user --namespace=exercise01
kubectl create secret generic wordpress-password --from-literal=password=user --namespace=exercise01
kubectl create secret generic wordpress-password-database --from-literal=password=user --namespace=exercise01

After we can deploy the rest of the system.

We have to create the rest elements of the exercise, started for the files of MariaDB, Wordpress and Drupal, in this order:

- persistent volume claim
- services
- deployments
- ingress

then the access policy will be added.

## Create TLS

I have created the tls using the PuTTYgen following the following instructions:

Create a public/private key file pair

To generate a public/private key file:

- Open puttygen.exe by double clicking on it.
  Note: It is a standalone executable and will run from anywhere.
- Click the Generate button, and move the mouse around to generate randomness.
  Note: PuTTYgen defaults to the desired SSH-2 RSA key.
