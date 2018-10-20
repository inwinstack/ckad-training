# Solution for Session 2 exercise 1

A command.sh script is provided to create all the elements.

**Requirements** 
openssl is needed to create TLS certificate:

-`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls/myblog-com-tls.key -out ./tls/myblog-com-tls.crt -subj "/CN=myblog.com"`

-`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./tls/drupal-myblog-com-tls.key -out ./tls/drupal-myblog-com-tls.crt -subj "/CN=drupal.myblog.com"`

## Exercise I

Deploy 3 applications:

- MariaDB Database (use StatefulSets). (tag 10.1)
- WordPress
- Drupal

Both Wordpress and Drupal will use the same MySQL deployment

### Solution notes:
I've used session 1 - exercise I as base for this exercise


## Exercise II
Add persistence to the three solutions using PVCs

### Solution notes:
PVC definition will be on the same yaml that the statefulset that will use it.
I'm using --- yaml separator instead of creating a k8s list object because I'm not sure
if it should be better to separate on different files.

## Exercise III
Make sure tht only WordPress and Drupal can access the database using NetworkPolicies

### Solution notes:


## Exercise IV
Add 2 Ingress rules:
- myblog.com: WordPress
- drupal.myblog.com/drupal: Drupal

Add a TLS certificate
Force HTTPS redirection

### Solution notes:

Drupal is not working properly so I've tested deploying a wordpress instead of drupal
