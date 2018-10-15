# S02 Exercise III Solution

Kubernetes exercise deploying a Wordpress instance connected to an instance of MariaDB.

## What's implemented

* Sidecar container that backs up the wp-content folder to a new volume every 10 minutes. Made sure that wordpress is working before backing up.
* Replaced the bitnami/wordpress with this javsalgar/wordpress:faulty.
    * Fixed: Added an init container that creates an empty /bitnami/.troll file.
    * Fixed: Added an ambassador container to fix MARIADB_HOST, which  is always accessing localhost.

## How to run

With *kubectl configured*, do `./command.bash` to start the app. The script will print the URLs to access.
