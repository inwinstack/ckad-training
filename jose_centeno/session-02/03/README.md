# Solution for Session 2 exercise 3

## Part I

Add a sidecar container that backs up the wp-content folder to a new volume every 10 minutes. Make sure that te application is working before backing up.

### Solution notes

I've created a docker image (jica/wordpress-backup) with a cron job that makes a tar of /pod-data folder to /backup/${date}.tgz.

So it is only necessary to create a sidecar container sharing wp-content folder.

TODO: Use env vars to set the schedule.

## Part II

Replace the bitnami/wordpress image with javsalgar/wordpress:faulty

- Issue1: The folder /bitnami/ needs an empty file called .troll. Add an init container to fix this.

- Issue2: MARIADB_HOST environment variable does not work, it is always accessing localhost. Add an ambassador container to fix this.

### Solution notes

- Issue1: fixed with an initContainer that touches the file.
- Issue2: With netcat (that is already available on busybox) you can redirect a connection.