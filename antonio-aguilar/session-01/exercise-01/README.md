# CKAD Training - Session 01

## Exercise 01

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

### Solution

Sorry, it is not completed. I have been able to deploy configMap object and MariaDB deployment successfully but unfortunately WP deployment have driven me mad. Nervertheless, I have a huge questions list and work to be done.

### Update
I've done every change suggested
I have used Secret object
But, still not able to get up & running wordpress pod...