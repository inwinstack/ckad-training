# Deliverable antonio_gamez/session-01/exercise-01
---

## Main goals
  
* Deploy 3 applications: 
    * MariaDB Database (use StatefulSets). (tag: 10.1)
    * WordPress
    * Drupal
* Both WordPress and Drupal will use the same MySQL deployment
* Add persistence to the three solutions using PVCs
* Make sure that only WordPress and Drupal can access the database using NetworkPolicies
* Add 2 Ingress rules 
    * myblog.com: WordPress
    * drupal.myblog.com/drupal: Drupal
* Add a TLS certificate
* Force HTTPS redirection







COSAS

1. .spec.updateStrategy antes no existia y el comportaiiento era otro (ondelete)
2. 
In Kubernetes 1.7 and later, StatefulSet’s .spec.updateStrategy field allows you to configure and disable automated rolling updates for containers, labels, resource request/limits, and annotations for the Pods in a StatefulSet.

On Delete
The OnDelete update strategy implements the legacy (1.6 and prior) behavior. When a StatefulSet’s .spec.updateStrategy.type is set to OnDelete, the StatefulSet controller will not automatically update the Pods in a StatefulSet. Users must manually delete Pods to cause the controller to create new Pods that reflect modifications made to a StatefulSet’s .spec.template.

Rolling Updates
The RollingUpdate update strategy implements automated, rolling update for the Pods in a StatefulSet. It is the default strategy when .spec.updateStrategy is left unspecified. When a StatefulSet’s .spec.updateStrategy.type is set to RollingUpdate, the StatefulSet controller will delete and recreate each Pod in the StatefulSet. It will proceed in the same order as Pod termination (from the largest ordinal to the smallest), updating each Pod one at a time. It will wait until an updated Pod is Running and Ready prior to updating its predecessor.



2. dd
3. The Headless Service provides a home for the DNS entries that the StatefulSet controller creates for each Pod that’s part of the set. Because the Headless Service is named mysql, the Pods are accessible by resolving <pod-name>.mysql from within any other Pod in the same Kubernetes cluster and namespace.

The Client Service, called mysql-read, is a normal Service with its own cluster IP that distributes connections across all MySQL Pods that report being Ready. The set of potential endpoints includes the MySQL master and all slaves.

Note that only read queries can use the load-balanced Client Service. Because there is only one MySQL master, clients should connect directly to the MySQL master Pod (through its DNS entry within the Headless Service) to execute writes

3. The volumeMounts.subPath property can be used to specify a sub-path inside the referenced volume instead of its root.


<!--   
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

2) **Configure SSL/TLS to secure the http traffic**. A straightforward way to do that is to generate a Let'sEncrypt free certificate and configure it in either the wordpress or the ingress service. -->
