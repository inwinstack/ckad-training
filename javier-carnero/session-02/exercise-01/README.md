# S02 Exercise I Solution

Kubernetes exercise deploying a Wordpress and Drupal instances connected to an instance of MariaDB.

## What's implemented

* Deploy 3 applications
    * MariaDB Database (tag: 10.1). It uses StatefulSets.
    * WordPress
    * Drupal
* Both WordPress and Drupal uses the same MySQL deployment
* Added persistence to the three solutions using PVCs  
* Only WordPress and Drupal can access the database using NetworkPolicies
* 2 Ingress rules
    * myblog.com: WordPress
    * drupal.myblog.com/drupal: Drupal
* TLS certificate

## How to run

With *kubectl configured*, do `./command.bash` to start the app. The script will print the URLs to access.
