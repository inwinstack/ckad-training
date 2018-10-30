

CKAD Bitnami K8s Training user: pablo_lara
---

# Exercise I: Deploy 3 applications
* MariaDB Database (tag: 10.1). Use StatefulSets.
* WordPress
* Drupal

## Commands.bash

Before executing this command, I would recommend executing in the command line
~~~
kubectl delete ns exercise-01
~~~
to ensure that *namespace=exercise-01* doesn't exist.

## Both WordPress and Drupal will use the same database.

In short, my MariaDB pod are exposed as a service that both can use. (same services)

## Add persistence to the three solutions using PVCs.

Persistence added

## Only WordPress and Drupal can access the database using NetworkPolices.

Implemented using policyTypes : Ingress

~~~
policyTypes:
- Ingress
~~~

## Add 2 Ingress rules.

*http://myblog.com* to WordPress
*http://drupal.myblog.com/drupal* to Drupal

** IMPORTANT: ** *http://drupal.myblog.com/drupal* worked fine. When I just do the final test it does not work. The logs show: (it worked fine by http-port)

~~~
Welcome to the Bitnami drupal container
Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-drupal
Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-drupal/issues

nami    INFO  Initializing apache
apache  INFO  ==> Patching httpoxy...
apache  INFO  ==> Configuring dummy certificates...
nami    INFO  apache successfully initialized
nami    INFO  Initializing php
nami    INFO  php successfully initialized
nami    INFO  Initializing mysql-client
nami    INFO  mysql-client successfully initialized
nami    INFO  Initializing libphp
nami    INFO  libphp successfully initialized
nami    INFO  Initializing drupal
mysql-c INFO  Trying to connect to MySQL server
mysql-c INFO  Found MySQL server listening at mariadb:3306
mysql-c INFO  MySQL server listening and working at mariadb:3306
Error executing 'postInstallation': Group '1001' not found

~~~

## Add TLS certificate

I use openssl to create the key:

~~~
openssl req -newkey rsa:2048 -nodes -keyout onboard.192.168.99.6.nip.io.key -x509 -days 365 -out onboard.192.168.99.6.nip.io.crt
Generating a 2048 bit RSA private key

~~~

## Force to HTTPS redirection

*Pending* (I've got a problem with Ingress annotation when I force https.)


##### Thanks so much.
