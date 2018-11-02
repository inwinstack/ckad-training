# Solution for Session 3 exercises

## Part 1: Give me a WordPress Char!

A WordPress Chart that allow setting:
1. The number of WordPress replicas 
2. Ingress (with TLS support)
3. NetworkPolicies
4. Persistence
5. Choosing between MySQL or MariaDB as the backend
6. MySQL dump backup CronJob

### Solution notes

Based on current stable/wordpress chart that support most of requested functionalities. I've done that because I have no much time and:
- I want to focus on some requirements I think are more valueable, 
- I think it is more usual to modify existent charts than creating new ones).

To get current wordpress chart

./helm fetch stable/wordpress -d exercise-01/charts-stable-wordpress

**5. Choosing between MySQL or MariaDB as the backend**

Once the new dependency (mysql) has been added on requirements.yaml file:
- Add bitnami charts repo:
`helm repo add bitnami https://charts.bitnami.com/bitnami`
- Get mysql dependency
`helm dependency update`

Get mysql chart is necessary to check the setup.

Then, I have:
- Added some mysql options to values.yaml to be used from templates
- Modified templates/deployment.yaml in order to use mysql when enabled.
- Modified helpers.tpl to add some functions.

_TODO:_
- Add comments 
- I have a problem (reported on slack) with helpers.

**6. MySQL dump backup CronJob** _Pending_

Like on session02-exercise02:
- Create a PVC that will store the backups
- Create a cronJob that executes mysqldump and store the result on the previous PVC

Other option:
- Create a PVC that will store the backups
- Create a cronJob that mount the backups-PVC and the MYSQL-data-volume and make a copy of the MySQL-data-volume on the backups one.

## Part 2: More features to the chart

Providing a set of plugins to install at deployment time

### Solution notes

I have added a initContainer to wordpress deployment that will:
1. Download all .zip plugin files from values.plugins list
2. Unzip the plugin and copy to wordpress plugins folder

## Part 3: Let's play with RBAC

I created this awesome WordPress  plugin that requires RBAC:
https://github.com/javsalgar/k8s-example-wp-plugin

- But it’s not complete. There are two TODOs 
- Once completed, add the proper RBAC rules to the chart

### Solution notes

I've created a fork to complete the plugin and published it at:
https://github.com/jica/k8s-example-wp-plugin.git on bin folder

I also had to modify solution II in order to follow redirections. So I can install the plugin published on github.

Finally, I had to create a serviceAccount, clusterRole and clusterRoleBinding to allow the plugin to access K8s API.

## Part 4: Let’s play with logging

Currently, the bitnami/wordpress:4.9.8-debian-9-r51 will not log Apache’s error log to stdout/stderr (/opt/bitnami/apache/logs/error_log), so it won’t be caught by EFK.

- I want that log to be seen in Kibana

How to do it? Once again, feel free to decide whatever suits you best

### Solution notes

I haven't tested this one so I have removed from the chart. 

The problem is that the logs are redirected to a file instead of stdout/stderr.

The solution could be create a volume for logs:
```
      volumes:
      - name: opt-bitnami
        emptyDir: {}
```

Add it to wordpress container, so /opt/bitnami is available from the volume:
```
        volumeMounts:
        - mountPath: /opt/bitnami/
          name: opt-bitnami
```

Finally, create a sidecar container that tail the error_log file
```
      - name: wordpress-log-errors
        image: ubuntu
        command: 
          - 'sh'
          - '-c'
          - "tail -f /bitnami/apache/logs/error_log"
        volumeMounts:
          - mountPath: /bitnami/
            name: opt-bitnami
```

Full deployment.yaml file on exercise4 folder.