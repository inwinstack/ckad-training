# S02 Exercise II Solution

Kubernetes exercise deploying a Wordpress instance connected to an instance of MariaDB.

## What's implemented

* Job for backing up a WordPress Database (each minute).
* It uses a volume for the backup.
* It uses mysqldump command.

## How to run

With *kubectl configured*, do `./command.bash` to start the app. The script will print the URLs to access.
