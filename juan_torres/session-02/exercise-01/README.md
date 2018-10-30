# Session 02

## Exercise 01

1. Deploy 3 applications(Both WordPress and Drupal will use the same MySQL deployment):
	* MariaDB Database (use StatefulSets). (tag: 10.1)
	* WordPress
	* Drupal

2. Add persistence to the three solutions using PVCs.

3. Make sure that only WordPress and Drupal can access the database using NetworkPolicies.

4. Add 2 Ingress rules
	* myblog.com: WordPress
	* drupal.myblog.com/drupal: Drupal
   
   Extra:
	* Add a TLS certificate.
	* Force HTTPS redirection.

# Solution in process

### Use user 1001 for mount volumes with not root containers:

Source: https://github.com/CrunchyData/crunchy-containers/issues/105

```
...
      securityContext:
        fsGroup: 1001
        runAsUser: 1001
...
```

### Update weave:

Source: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#configuration-options

```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
curl -SL https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n') -o /opt/bitnami/kubernetes/manifests/weave-net.yaml
```

### Ingress TLS

1 - **Cert Manager**

```
kubectl create namespace cert-manager
helm install --name cert-manager stable/cert-manager --namespace cert-manager
```

2 - **TLS with secret**

```
openssl req -x509 -nodes -days 100 -subj "/CN=wordpress.example.es" -newkey rsa:1024 -keyout cert/wordpress.key -out cert/wordpress.crt
openssl req -x509 -nodes -days 100 -subj "/CN=drupal.example.es" -newkey rsa:1024 -keyout cert/drupal.key -out cert/drupal.crt
kubectl create secret tls wordpress-tls --key cert/wordpress.key  --cert cert/wordpress.crt -n exercise-01
kubectl create secret tls drupal-tls --key cert/drupal.key  --cert cert/drupal.crt -n exercise-01
```
