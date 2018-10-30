

CKAD Bitnami K8s Training user: pablo_lara
---

# Exercise III: Adding containers to a WordPress Pod

## Commands.bash

Before executing this command, I would recommend executing in the command line
~~~
kubectl delete ns exercise-03
~~~
to ensure that *namespace=exercise-03* doesn't exist.

## Add an init container to fix issue 1:

~~~
initContainers:
  - name: init-troll
    image: busybox
    volumeMounts:
    - name: wp-data
      mountPath: /bitnami/wordpress
    command: ["/bin/sh", "-c", "touch /bitnami/wordpress/.troll;"]
~~~

## Add an ambassador container to fix issue 2:
~~~
- name: wp-socat-ambassador #Ambassador container
  image: alpine/socat
  command: ['/bin/sh','-c', 'socat tcp-listen:3306,fork,reuseaddr tcp-connect:mariadb:3306;']

~~~

## Add a sidecar container that backs up the wp-content folder to a new volume every 10 minutes:
~~~
image: woahbase/alpine-ssh
volumeMounts:
- name: wp-data
  mountPath: /bitnami/wordpress/wp-content
command:
- "/bin/sh"
- "-c"
- |
  while true; do
    if curl http://myblog.com/wp-login.php; then
      echo "WordPress ready for backup";
      rsync -av --delete /wp-data /wp-backup;
      echo "Backup completed";
    else
      echo "Backup impossible";
    fi
    sleep 600;
  done;
~~~

Once the commands.bash script is executed, open a web browser and navigate to the URL below:

http://myblog.com

##### Thanks so much.
