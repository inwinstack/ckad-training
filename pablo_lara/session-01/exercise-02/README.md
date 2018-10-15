

CKAD Bitnami K8s Training user: pablo_lara
---

# Exercise II: Wordpress + MariaDB with replication

## Commands.bash

Before executing this command, I would recommend executing in the command line
~~~
kubectl delete ns exercise-02
~~~
to ensure that *namespace=exercise-02* doesn't exist.

## Every pod should configure the CPU/RAM requested to the cluster, and the limits for them.

~~~
resources:
  requests:
    cpu: "250m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"
~~~

## To ensure there won't be more than 40% of the replicas unavailable when running rolling updates on slave deployment:
~~~
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 40%
~~~
## Scale slaves to 5 replicas.
~~~
$ kubectl scale deploy mariadb-slave --replicas=5 --namespace=exercise-02
~~~

Once the commands.bash script is executed, open a web browser and navigate to the URL below:

http://kubernestes:32520

## Install HyperDB WP plugin and configure it to balance SQL request:

I don't know how to do it before the deadline. I'll try to do before the next session. (5 Oct/18)
 
##### Thanks so much.
