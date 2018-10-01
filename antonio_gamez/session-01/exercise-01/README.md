
  # Deliverable session-01/exercise-01
  
  ## Goals
  
* All the resources should be created under the *exercise-01* namespace.

* The WP site should use a MariaDB database.

* Use ConfigMaps and Secrets to configure both MariaDB and WP.

* Every container should have the proper readiness and liveness probes configured.

* Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP version and use 4.9.8 in the canary deployment.

* Wordpress should be publicly available while MariaDB should only be accessible internally (you can consider your cluster supports LoadBalancer service type).

  
## Steps to set up this scenario

1) From this directory, run `kubectl create -f ./resources`

2) Open in a browser:  http://18.213.63.179:30080 or  https://18.213.63.179:30443.

3) Enjoy your new k8s-flavored Worpress :)

## Remarks about the proposed solution

>Use ConfigMaps and Secrets to configure both MariaDB and WP.

Debemos iusar seleadd sicrets, pero por ahira no lo he hecho. etsan todos guardado en ficheros para que sea mas facil la recreacion de elementos en fases de deasrollo.


>* Every container should have the proper readiness and liveness probes configured.

Ha habido preoblema con eso, porqe maria tardava un pcoo y ha habidi que incrementar los timers y timeouts para que no reinicie infinitamente


>Use a canary deployment for WP. Consider the version 4.9.7 as the stable WP version and use 4.9.8 in the canary deployment.

Se ha elegido el selector terna (x.x,free) para asi coger en el sevicio todos. confi acuaul una replica de ambos.
stikcy con ese parametero.


## Technical debt
  
This scenario is *absolutely* not ready for production purposes. There remain two major issues to be addresed:

1) **Expose the service in a common 80 port**. Two alternatives here: 
	1.1) Use **LoadBalancer** service: in order to use a LoadBalancer in AWS, we should move to an EKS cluster for that, or install the AWS addon that allows you to create ELBs on demand.
	1.1) Use an **Ingress** controller: we have to install the Ingress addon into the cluster (e.g. nginx or HAProxy) and create the rules to forward the traffic

2) **Configure SSL/TLS to secure the http traffic**. A straightforward way to do that is to generate a Let'sEncrypt free certificate and configure it in either the wordpress or the ingress service.



