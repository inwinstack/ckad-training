Click [here](https://github.com/bitnami-labs/ckad-training/blob/master/README.md) for the README original :-)

# Exercise I

## WP + MariaDB with Canary

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace
* The WP site should use a MariaDB database
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* Every container should have the proper readiness and liveness probes
configured
* Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP
version and use 4.9.8 in the canary deployment
* Wordpress should be publicly available while MariaDB should only be accessible
internally (you can consider your cluster supports LoadBalancer service type)

## Instructions

Give execution permission to the file and execute it:

```
chmod u+x commands.bash
./commands.bash
```

> The URL to access Wordpress will be displayed in the script output

### Notes

You need to guarantee Session Affinity when using Canary Deployments. See https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-ipvs