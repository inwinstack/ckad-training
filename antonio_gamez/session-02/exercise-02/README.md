# Deliverable antonio_gamez/session-01/exercise-02 
---

## Main goals
  
* Job for backing up a WordPress Database
  * You can reuse the WP + MariaDB deployment from exercise 1
* Use a volume for the backup
* Use mysqldump command (find a container or build your own one). 
  * You may need to create a docker account for uploading your containers.


## Steps to set up this scenario

1) From this directory, run the `./commands.sh` script.
2) Check `kubectl get cronjob` has 0/1 active jobs and `kubectl get pods`
3) The data will be located at the volume created by the pvc: `kubectl get pvc mariadbdump-pvc`.


## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals. For the sake of simplicity, all the topics already covered in previous exercises will not be discussed here.

> Use mysqldump command (find a container or build your own one). 

The image `camil/mysqldump` is being used, which interanlly uses mysqldump command to connect to a MySQL/MariaDB server and exports the content of the databases. The connfiguration passed throuh configmaps and secrets.

## Technical debt
  
1) Upload securely the collected data somewhere outside the cluster (at least, outside the node; a `podAntiAffinity` could fit in this context).

2) Since we are trusting a non reliable 3rd party image (not as Bitnami or Stacksmith ones :-P ) and, indeed, delegating a critical task, we definitely should move to another either self-managed or trusted way to perform this task.