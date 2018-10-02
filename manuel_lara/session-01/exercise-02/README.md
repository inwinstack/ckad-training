# WordPress for Kubernetes

With this project is possible to deploy a WordPress blog making use the WordPress Docker imager created by [Bitnami](https://bitnami.com/).

 

>**Note:**
>
>The purpose of this project is purely educational. That's why both ```readinessProbe``` and ```livenessProbe``` are configured with non very appropiate values on purpose in order to be able to see the failures in the POD's description log.

### Prerequisites

To deploy a WordPress blog using this project is necessary to have a working Kubernetes instance and to have the ```kubectl``` command line configured properly.

An easy way to have a Kubernetes instance working in place is deploying an AWS EC2 instance making use of the [Kubernetes AMI provided by Bitnami](https://bitnami.com/stack/kubernetes-sandbox/cloud/aws/amis).


## Usage

To deploy a WordPress instance is only necessary to run the ```command.bash``` file.

```
./command.bash.sh
```

The previous scrip also creates a tunnel to expose the WordPress using a port forwarding, so to see the blog is only necessary to follow this link:

http://localhost:8080

The ```command.bash``` script will be running until killing the process, which will also break the tunnel. The following command can be used to reopen the tunnel:

```
kubectl port-forward \
    $(kubectl get pods -l app=exercise-01,tier=frontend \
    -o jsonpath="{.items[0].metadata.name}" --namespace=exercise-01) 8080:80 \
    --namespace=exercise-01
```

Eventually, if it's needed to destroy the blog, just run this other script:

```
./destroy.sh
```

This deployment project will deploy a WordPress application and a MySQL database. Both of them will be deployed as cluster with, at least, two nodes and with the posibility to auto scale up to ten. To guarantee the stability of Kubernetes, the containers will be deployed with a limitation in the use of CPU and memory.

This project will also take in account the control of the instances number deployed guaranteeing at all times the demanded number of replicas.