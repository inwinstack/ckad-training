# Deliverable antonio_gamez/session-02/exercise-01
---

## Main goals
  
* Deploy 3 applications: 
    * MariaDB Database (use StatefulSets). (tag: 10.1)
    * WordPress
    * Drupal
* Both WordPress and Drupal will use the same MySQL deployment
* Add persistence to the three solutions using PVCs
* Make sure that only WordPress and Drupal can access the database using NetworkPolicies
* Add 2 Ingress rules (changes to other domains are allowed)
    * myblog.com: WordPress
    * drupal.k8s.governify.io/drupal: Drupal
* Add a TLS certificate
* Force HTTPS redirection


## Steps to set up this scenario

1) (Optional) If you want to replicate this scneario with your own cluster, add the the following entries to your local `host` file:
    * <your_cluster_ip> k8s.governify.io 
    * <your_cluster_ip> www.k8s.governify.io 
    * <your_cluster_ip> drupal.k8s.governify.io 
    * <your_cluster_ip> www.drupal.k8s.governify.io 
2) From this directory, run the `./commands.sh` script.
3) Open in a browser:  https://k8s.governify.io or  https://drupal.k8s.governify.io/drupal
4) Enjoy your new k8s-flavored Wordpress/Drupal with Ingress and Persistence :)




## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals. For the sake of simplicity, all the topics already covered in previous exercises will not be discussed here.

>MariaDB Database (use StatefulSets). (tag: 10.1)

Two different `StatefulSet` have been created: one for the master (1 replica), and 2 for the slaves.
The `bitnami/mariadb:10.1` image requires running as a non-root container, hence a spec.securityContext has been added as follows:
```yaml
securityContext:
    runAsUser: 1001
    fsGroup: 1001
```
The specific MariaDB configuration is being passed through the container by mounting a `ConfigMap` as follows: 
```yaml
# ...
    volumeMounts:
    # ...
    - name: config
        mountPath: /opt/bitnami/mariadb/conf/my.cnf
        subPath: my.cnf
volumes:
    - name: config
    configMap:
        name: mariadb-slave-config-cm
```

It is also remarkable that `spec.updateStrategy` did not exist before K8S 1.7 for StatefulSets, so the pods were not automatically updated. If this strategy was desired, `updateStrategy: onDelete`.

Regarding the services, a headless (`clusterIP: None`) service (`mariadb-slave`) has been created for the MariaDB `slave` pods, whereas the `master` has an internal ClusterIP service (`mariadb`) exposed. 

This configuration allows making accessible by resolving `<pod-name>.mariadb-slave` from within any other Pod in the same cluster and namespace.

> Both WordPress and Drupal will use the same MySQL deployment

These two services are using the same MariaDB cluster at `mariadb:3306`; since each one is configured by default to use different table prefixes, there is no conflict.

Nevertheless, this is not the optimal way to address the problem as described in the next section.

> Add persistence to the three solutions using PVCs

On the one hand, `StatefulSets` are using `volumeClaimTemplates` to automatically create `PersistentVolumeClaim`; on the other hand, both Wordpress and Drupal have their own `PersistentVolumeClaim`. For the sake of simplicity, all of them have been provisioned with the same size.


Nevertheless, if our cluster is created with the feature-gate `ExpandPersistentVolumes=true` (enabled by default in k8s > 1.11) and we are using an in-tree volume plugin (`AWS-EBS, GCE-PD, Azure Disk, Azure File, Glusterfs, Cinder, Portworx, and Ceph RBD`), it is possible to resize the volumes as described in https://kubernetes.io/blog/2018/07/12/resizing-persistent-volumes-using-kubernetes/. 

Specifucally, the `PersistentVolumeClaim` created are as follows: 

```bash
> kubectl get pvc
NAME                                STATUS    VOLUME      CAPCACITY  ACCESSMODE           
mariadb-data-mariadb-master-sts-0   Bound     pvc-09fa...   4Gi        RWO 
mariadb-data-mariadb-slave-sts-0    Bound     pvc-0c77...   4Gi        RWO
mariadb-data-mariadb-slave-sts-1    Bound     pvc-1f63...   4Gi        RWO
wordpress-pvc                       Bound     pvc-d76f...   4Gi        RWO
drupal-pvc                          Bound     pvc-d739...   4Gi        RWO
```

> Make sure that only WordPress and Drupal can access the database using NetworkPolicies

Initially, the version of the network technology (Weave) used in the sandbox cluster is was not compatible. To fix it we can either create a new sandbox instance or update the Weaver version by executing:
```bash
$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
First, a deny-all policy default has been created. Then, we specificallly allow `WP/DP --> DB` connections, as defined in the following `NetworkPolicy` excerpt: 

```yaml
spec:
  podSelector:
    matchLabels:
      tier: database
  ingress:
    - from:
        - podSelector:
            matchLabels:
              tier: frontend
      ports:
        - protocol: TCP
          port: 3306
```

> Add 2 Ingress rules: `https://<base_domain>` and `https://drupal.<base_domain>/drupal` 

The cluster is supposed to have installed an `nginx-ingress-controller`, if it is not, please follow theis guide: https://kubernetes.github.io/ingress-nginx/deploy.

The WordPress Ingress rule is straightforward, since it is a simple redirection to the `wordpress` in `/` path of the `<base_domain>`. Contrary, the `drupal.<base_domain>/drupal` handling is a bit tricky. 

First, an Ingress rule for `/drupal` is required, but rhe traffic should be forwarded to the root path inside the application, that is the reason behind `rewrite-target: /`, as depicted below:

```yaml
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  #tls: ...
  rules:
  - host: drupal.<base_domain>
    http:
      paths:
      - path: /drupal
        backend:
          serviceName: drupal
          servicePort: http
```

Next, a further rule is needed to handle the `/` traffic. The expected beavior is to redirect to the `/drupal` path, so that it can be handled by the previous rule. 
Even if an specific annotation already exists to address this issue, an effective way is to simplily inject the nginx configuration snnipet in charge of performing the rewrite, as observed in the annotation `rewrite ^/(.*)$ /drupal/$1 redirect;` below:

```yaml
  annotations:
    nginx.ingress.kubernetes.io/configuration-snippet: |
      rewrite ^/(.*)$ /drupal/$1 redirect; # do the 301 redirect to /.../ -> /drupal/.../
spec:
  #tls: ...
  rules:
  - host: drupal.<base_domain>
    http:
      paths:
      - path: /
        backend:
          serviceName: drupal
          servicePort: http
```

> Force HTTPS redirection

It is simply achived by creating the following annotations:

```yaml
annotations:
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-redirect: "true" # default true
```

However, this configuration presents problem when configuring HTTP/2, which requieres end-to-end encryption (not only end-to-reverse-proxy). 
This behavior could be configured by installing Ingress with the flag `--enable-ssl-passthrough` and then annotating the rules with `nginx.ingress.kubernetes.io/ssl-passthrough: "true"`.


> Add a TLS certificate

A first approach to this issue would start by creating a cluster-self-signed cert for the `<base_domain>` and using it in the Ingress. However, since we are using an static IP which can be easly assigned to an A DNS record, we can leverage from a trusted CA cert provider (such as Let's Encrypt).

An easy manner to face the certificate lifecycle is to use `cert-manager` (former `kube-lego`) since it can be used to obtain certificates from a CA using the ACME protocol. The ACME protocol supports various challenge mechanisms which are used to prove ownership of a domain so that a valid certificate can be issued for that domain.

First, `cert-manager` should be installed by typing: `helm install  --name cert-manager  --namespace kube-system  stable/cert-manager`. Note you need to have Helm (https://helm.sh/) installed. Now, it is possible to create `Issuer` and `Certificate` API objects.

First, an `Issuer` with the production ACME endpoint is created. We also define the kind of verification (DNS or HTTTP). See 
  https://cert-manager.readthedocs.io/en/latest/tutorials/acme/dns-validation.html for more information.

```yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: Issuer
metadata:
  name: letsencrypt-production
  namespace: s02-exercise-01
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: <your_email>
    privateKeySecretRef:
      name: letsencrypt-production
    http01: {}
```

Then, a `Certificate` is requested by the aforementioned `Issuer` for a common name (CN) and its alternative names (up to 100).

```yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
  name: <base_domain>
  namespace: s02-exercise-01
spec:
  secretName: <base_domain>-tls
  issuerRef:
    name: letsencrypt-production
  commonName: <base_domain>
  dnsNames:
  - <base_domain>
  - drupal.<base_domain>
  acme:
    config:
    - http01:
        ingressClass: nginx
      domains:
      - <base_domain>
      - drupal.<base_domain>
```
After creating these API objects, a new certificate is going to be requested and saved as a secret with name: `<base_domain>-tls`. 

In the Ingress rule definition, it is needed to specify a tls section pointing to the secret that contains the certificate. The `kubernetes.io/tls-acme: "true"` annotation enables the autorenewal of the certificates.

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
# ...
  annotations:
    kubernetes.io/tls-acme: "true"
    # ...
spec:
  tls:
  - hosts:
    - <base_domain>
    secretName: <base_domain>-tls
  rules:
  # ...
```


## Technical debt
  
1) Both WordPress and Drupal, for the sake of simplicity, are using the same database, sharing, thus, the same db username and password.
A way to face this problem is to create two different databases. If the `bitnami/mariadb` had an env var to do so, the problem is quite straightforward. 
Otherwise, we will need to create an `initcontainer` to prepopulate the `docker-entrypoint-initdb.d` with a SQL script creating both the desired databases.