bash7# Deliverable antonio_gamez/session-01/exercise-03
---

## Main goals
  
* Part 1:
    * Add a *sidecar container* that backs up the `wp-content` folder to a new volume every 10 minutes.
    * Make sure that the application is working before backing up.
* Part 2:
    * Replace the `bitnami/wordpress` with this one: `javsalgar/wordpress:faulty`
        * Issue 1: The folder `/bitnami/` needs an empty file called `/bitnami/.troll`. 
            * Add an *init container* to fix this.
        * Issue 2: `MARIADB_HOST` environment variable does not work, it is always accessing `localhost`.
            * Add an *ambassador container* to fix this


## Steps to set up this scenario

1) From this directory, run the `./commands.sh` script.
2) Enjoy your new k8s-flavored Wordpress with InitContainers, Sidecar and Ambasador containers added.


## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals. For the sake of simplicity, all the topics already covered in previous exercises will not be discussed here.

> Add a *sidecar container* that backs up the `wp-content` folder to a new volume every 10 minutes. Make sure that the application is working before backing up.

The usual WordPress pod has been extended with a new container, `wordpress-backupper` and two new volumnes: `wordpress-backupper-shared` and `wordpress-backupper-data`. First one is mounted in both main and sidecar containers in order to share the `wp-content` folder. Then, `wordpress-backupper-data` is mounted to the sidecar container for backup purposes. A simple script using rsync performs the syncronizing task after checking that a curl to `wp-login.php` page is ok.


> Issue 1: The folder `/bitnami/` needs an empty file called `/bitnami/.troll`. 
            
An *init container* has been added for writing in the shared volume with the `/bitnami/` mount point. Then, a simple `touch` creates the file which the faulty WordPress needs.

```yaml
initContainers:
- name: mariadb-entrypoint
    image: busybox
    volumeMounts:
    - name: wordpress-data
        mountPath: /wordpress
        subPath: wordpress
    command: 
    - sh
    - '-c'
    - touch /wordpress/.troll
```

>Issue 2: `MARIADB_HOST` environment variable does not work, it is always accessing `localhost`.

An *ambassador container* has been added with a simple `socat` command that, listening on localhost:3306, forwards all the traffic from this point to `mariadb:3306`

```yaml
- name: wordpress-socat
    image: alpine/socat
    command: 
    - sh
    - -c
    - socat tcp-l:3306,fork,reuseaddr tcp:mariadb:3306
```

## Technical debt
  
1) Upload securely the collected data somewhere outside the cluster (at least, outside the node; a `podAntiAffinity` could fit in this context).
2) Use another image (even create a nre one) instead of the outdated one with curl and rysnc.
