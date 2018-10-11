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


> NOTES: sidecar BK wp-content en volumen aparte
    usar otra imagen de WP con proglemas
        initcontainer que arrelga eso
        amassador para la hardocear socat, netcat

## Steps to set up this scenario

1) From this directory, navitate to the `part-01` or `part-02` directories, and from there run the corresponding `./commands.sh` scripts.
2) Enjoy your new k8s-flavored Wordpress with InitContainers, Sidecar and Ambasador containers added.


## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals. For the sake of simplicity, all the topics already covered in previous exercises will not be discussed here.

> Add a *sidecar container* that backs up the `wp-content` folder to a new volume every 10 minutes. Make sure that the application is working before backing up.

The usual WordPress pod has been extended with a new container, `wordpress-backupper` and two new volumnes: `wordpress-backupper-shared` and `wordpress-backupper-data`. First one is mounted in both main and sidecar containers in order to share the `wp-content` folder. Then, `wordpress-backupper-data` is mounted to the sidecar container for backup purposes. A simple script using rsync performs the syncronizing task after checking that a curl to `wp-login.php` page is ok.


## Technical debt
  
1) Upload securely the collected data somewhere outside the cluster (at least, outside the node; a `podAntiAffinity` could fit in this context).
2) Use another image (even create a nre one) instead of the outdated one with curl and rysnc.
