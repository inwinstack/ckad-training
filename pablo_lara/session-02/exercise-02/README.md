

CKAD Bitnami K8s Training user: pablo_lara
---

# Exercise II: Job for backing up a WordPress Database

## Commands.bash

Before executing this command, I would recommend executing in the command line
~~~
kubectl delete ns exercise-02
~~~
to ensure that *namespace=exercise-02* doesn't exist.

## The MariaDB container is running as non-root. More specifically as the user 1001. To solve this, I've used:
~~~
securityContext:
  runAsUser: 1001
  fsGroup: 1001
~~~
### Article of reference: https://engineering.bitnami.com/articles/running-non-root-containers-on-openshift.html

To backing up a WP database, I've used *mysqldump-cronjob.yaml* , it does a backup every minute.
~~~
  schedule: "*/1 * * * *"
~~~

## Use mysqldump command. (with image of Bitnami)
~~~
image: bitnami/mariadb:latest

command: ["/bin/bash", "-c", "mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASS $DB_DATABASE > /bitnami/mysqldump/ndb.sql;"]

~~~

Once the commands.bash script is executed, open a web browser and navigate to the URL below:

http://myblog.com

##### Thanks so much.
