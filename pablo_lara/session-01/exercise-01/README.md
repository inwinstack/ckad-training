

CKAD Bitnami K8s Training user: pablo_lara
---

# Exercise I: Wordpress + MariaDB with Canary

I've used all files include the folder "exercise-01". Also, I've created a new files like *wordpress-secret.yaml* or *mariadb-secret.yaml* in order to pass sensitive information.

## Commands.bash

Before executing this command, I would recommend executing in the command line
~~~
kubectl delete ns exercise-01
~~~
to ensure that *namespace=exercise-01* doesn't exist.

## Liveness & Readiness Probe

In the configuration file, you can see that the Deployment both *wordpress-deployment.yaml* and *wordpress-canary-deployment.yaml* define the same probes. An HTTP request to a specific route server.
~~~
livenessProbe:
    initialDelaySeconds: 160
    periodSeconds: 30
    httpGet:
      scheme: HTTP
      path: /wp-login.php
      port: 80
readinessProbe:
    initialDelaySeconds: 30
    periodSeconds: 5
    httpGet:
      scheme: HTTP
      path: /wp-login.php
      port: 80
~~~

In *mariadb-deployment.yaml* I've used:
~~~
livenessProbe:
  exec:
    command:
    - sh
    - -c
    - "mysqladmin ping -u root -p${MARIADB_ROOT_PASSWORD}"
  initialDelaySeconds: 90
  periodSeconds: 30
readinessProbe:
  exec:
    command:
    - sh
    - -c
    - "mysqladmin ping -u root -p${MARIADB_ROOT_PASSWORD}"
  initialDelaySeconds: 35
  periodSeconds: 10
~~~

At last, I've configured *wordpress-canary-deployment.yaml* like *canary version with wordpress 4.9.8*
~~~
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
mariadb         ClusterIP      10.105.10.15    <none>        3306/TCP       3m
wordpress-svc   LoadBalancer   10.102.37.101   <pending>     80:32500/TCP   3m
~~~
~~~
$ kubectl get pods --namespace=exercise-01
NAME                                           READY   STATUS    RESTARTS   AGE
mariadb-deployment-7c484dd4d5-zvm5s            1/1     Running   0          1m
wordpress-canary-deployment-7d69b68bd9-ttvlr   1/1     Running   0          1m
wordpress-deployment-77f4c9d557-5q7fq          1/1     Running   0          1m
wordpress-deployment-77f4c9d557-hqwk4          1/1     Running   0          1m
wordpress-deployment-77f4c9d557-xl5k6          1/1     Running   0          1m
~~~

Once the commands.bash script is executed, open a web browser and navigate to the URL below:

http://kubernestes:32500

##### Thanks so much.
