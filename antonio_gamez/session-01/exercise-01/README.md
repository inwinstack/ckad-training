# Deliverable antonio_gamez/session-01/exercise-01
---

## Main goals
  
* All the resources should be created under the *exercise-01* namespace.

* The WP site should use a MariaDB database.

* Use ConfigMaps and Secrets to configure both MariaDB and WP.

* Every container should have the proper readiness and liveness probes configured.

* Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP version and use 4.9.8 in the canary deployment.

* Wordpress should be publicly available while MariaDB should only be accessible internally (you can consider your cluster supports LoadBalancer service type).

  
## Steps to set up this scenario

1) From this directory, run `kubectl create -f ./resources` or exec the `./commands.sh` script.
2) Open in a browser:  http://<your_cluster_ip>:30080 or  https://<your_cluster_ip>:30443.
    2.1) If you do know the IP, a way to retrieve it is `kubectl config view | grep server`
3) Enjoy your new k8s-flavored Wordpress :)

## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals:

>Use ConfigMaps and Secrets to configure both MariaDB and WP.

Due to the dummy nature of this repository, both config and secrets files have been committed. Instructions about how to use the Bitnami's Sealsecret solution are provided as comments as part of the `commands.sh`file.

> Every container should have the proper readiness and liveness probes configured.

To address this problem, `livenessProbe` and `readinessProbe` have been used. The configuration of these object is straightforward. The only aspect differing from the default params is the `initialDelaySeconds: 120`, so that the delay while configuring database was considered.

>Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP version and use 4.9.8 in the canary deployment.

Since each resource in this exercise defines a 3-tuple of `app=wordpress, tier=(frontend|database), stage=(production|canary)`, this goal has been addressed by creating a service that selects `app=wordpress, tier=frontend` leaving free the `stage` label. 
In order to stick the user session, as much as possible, to the pod which responded the first, `sessionAffinity: ClientIP`is defined in the service definition.
When using ingress, other fine-grained options are available. See https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/affinity/cookie. 

> Wordpress should be publicly available while MariaDB should only be accessible internally (you can consider your cluster supports LoadBalancer service type)

In order to publicly expose the WordPress service, a LoadBalancer service type has been used. Due to the IAM restrictions, EC2 instances are not allowed to automatically provision an N/E LB. That is why it has been created manually.
Specifically, a [Network Load Balancer](https://kubernetes.io/docs/concepts/services-networking/service/#network-load-balancer-support-on-aws-alpha) has been created and configured to forward the requests from the NLB IP to the proper clusterIP of the services.
In the Kubernetes service, the policy `externalTrafficPolicy: Local` has been set. This means that it will never do forwarding traffic to other nodes and thereby it will preserve the original source IP address, being consistent with the `sessionAffinity: ClientIP` already set for canary deployments.
Furthermore, note that for using the NLB (instead of the Elastic Load Balancer), an extra annotation should be included: `service.beta.kubernetes.io/aws-load-balancer-type: nlb`


## Technical debt
  
This scenario is *absolutely* not ready for production purposes. Specifically, there remain two major issues to be addressed:

1) **Expose the service in a common 80 port**. Two alternatives here: 
    1.1) Use **LoadBalancer** service: in order to use a LoadBalancer in AWS, we should move to an EKS cluster for that, or install the AWS addon that allows you to create ELBs on demand.
    1.1) Use an **Ingress** controller: we have to install the Ingress addon into the cluster (e.g. nginx or HAProxy) and create the rules to forward the traffic

2) **Configure SSL/TLS to secure the http traffic**. A straightforward way to do that is to generate a Let'sEncrypt free certificate and configure it in either the wordpress or the ingress service.
