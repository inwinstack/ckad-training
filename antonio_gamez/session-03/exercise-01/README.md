# Deliverable antonio_gamez/session-03/exercise-01
---

## Main goals
  
* Create a full Wordpress chart:
  * Part 1. Chart.
    * Setting the number of WordPress replicas
    * Ingress (with TLS Support)
    * NetworkPolicies
    * Persistence
    * Choosing between MySQL or MariaDB as the backend
    * MySQL dump backup CronJob
  
  * Part 2. Chart
    * Providing a set of plugins to install at deployment time
  
  * Part 3. RBAC
    * Plugin with RBAC: https://github.com/javsalgar/k8s-example-wp-plugin 
      * But it’s not complete. There are two TODOs 
    * Once completed, add the proper RBAC rules to the chart
  
  * Part 4. Kibana logging:
    *  Currently, the `bitnami/wordpress:4.9.8-debian-9-r51` will not log Apache’s error log to stdout/stderr, so it won’t be caught by EFK. I want that log to be seen in Kibana
  
  * Part 5. Metrics + grafana
    * Find existing / create an exporter with WP API
    * Feel free to decide which metrics you want to export (a pair of metrics should be more than enough)
    * Add an option to the chart to enable the metrics
    * With the metrics, create a simple Grafana dashboard
  
  * Part 6. Create chart repo:
    * Create a repository with your created chart
      (crear server node)* Use a folder inside the sandbox, for example and create a simple server
    * Add it to Kubeapps




## Steps to set up this scenario

1) (Optional) If you want to replicate this scenario with your own cluster, add the following entries to your local `host` file:
    * <your_cluster_ip> k8s.governify.io 
    * <your_cluster_ip> www.k8s.governify.io 
2) Open `./commands.sh` file and follow the instructions.
3) Open in a browser:
    1) https://k8s.governify.io for parts 1-3.
    2) http://127.0.0.1:9200 to use Elasticsearch
    3) http://127.0.0.1:5601 to use Kibana
    4) http://127.0.0.1:9090 to use Prometheus
    5) http://127.0.0.1:3000 to use Grafana
    6) http://127.0.0.1:8080 to use Kubeapps Dashboard
    7) http://127.0.0.1:8081 as your local chart repo
4) Enjoy your new k8s-flavored full-fledged Wordpress chart with monitoring :)


## Remarks about the proposed solution

Discussion about some non-trivial aspects of the solution and the expected goals. For the sake of simplicity, all the topics already covered in previous exercises will not be discussed here.

> Chart with:
  > "Setting #replicas", 
  > "Ingress",
  > "NetworkPolicies",
  > "Persistence",
  > "Choosing MySQL || MariaDB",
  > "MySQL dump CronJob".

All the instructions regarding the chart have been provided in the README.md of the chart.
  

> Providing a set of plugins to install at deployment time.

In the `preinstalledPlugins` array of the `values.yaml` you can add as much `pluginName:version` item as you want. Example:
```yaml
wordpressConfig:
  ...
  preinstalledPlugins:
    - dark-mode.3.1
    - jetpack.6.6.1
    - ...
  ...
```

A sidecar container will wait until wordpress is fully deployed and will download and install the files into the Wordpress main container.

```bash
{{- range $key, $value := .Values.wordpressConfig.preinstalledPlugins }}
echo "------ BEGIN installing wordpress plugin {{ $value }} ------"
echo "Downloading plugin -{{ $value }}-..."
curl -L http://downloads.wordpress.org/plugin/{{ $value }}.zip -o /tmp/{{ $value }}.zip -s
echo "Extracting plugin -{{ $value }}- to -/wordpress/wp-content/plugins-..."
unzip   /tmp/{{ $value }}.zip -d /wordpress/wp-content/plugins
rm -rf  /tmp/{{ $value }}.zip
echo "------ END installing wordpress plugin {{ $value }} ------"
{{- end }}
```


> Install and edit plugin. Add RBAC rules to the chart.

A `ServiceAccount` is needed for granting the WP plugin the access to the k8s API. This `ServiceAccount` is mapped to a `ClusterRoleBinding` (which only grants `get`, `watch` and`list` over `deployment` objects).

By executing `kubectl create -f './rbac'` we define the RBAC-stuff to get the chart working.

Then, after downloading the plugin, some tweaks must be performed:

  * `PUT_HERE_DNS_OF_API_SERVER:443` becomes `kubernetes.default.svc:443`.
  * `PUT_HERE_API_PATH_TO_DEPLOYMENTS:443` becomes `apis/extensions/v1beta1/namespaces/{{ .Values.namespace }}/deployments`.
  * `PUT_HERE_THE_PATH_TO_THE_SERVICE_ACCOUNT_TOKEN_FILE:443` becomes `/var/run/secrets/kubernetes.io/serviceaccount/token`.
  * `WP_K8S_PLUGIN_DEPLOYMENT_NAME` env var is loaded with `{{ template "fullname" . }}-deploy` (name of the current deployment).

An excerpt of the replacing logic is depicted below:

```bash
sed -i 's/PUT_HERE_DNS_OF_API_SERVER:443/kubernetes.default.svc:443/g' /tmp/k8s-example-wp-plugin-master/k8s_example_plugin.php
sed -i 's/PUT_HERE_API_PATH_TO_DEPLOYMENTS/apis\/extensions\/v1beta1\/namespaces\/{{ .Values.namespace }}\/deployments/g' /tmp/k8s-example-wp-plugin-master/k8s_example_plugin.php
sed -i 's/PUT_HERE_THE_PATH_TO_THE_SERVICE_ACCOUNT_TOKEN_FILE/\/var\/run\/secrets\/kubernetes.io\/serviceaccount\/token/g' /tmp/k8s-example-wp-plugin-master/k8s_example_plugin.php
```

Finally, after enabling the plugin and dragging it into a wordpress widget it shows a beautiful  `deployments: 1`, after being granted to harvest the k8s deployment API.


> Get wordpress:4.9.8-debian-9-r51 stdout/stderr logs in ELK
 
We need to get the logs/errors printed into the stdout/stderr. An initial approach is simply run `tail -f ` in a sidecar container. 

A better solution could be using `inotifywait` from the `inotify-tools` package and wait for `close_write`, `moved_to` or `create` events. For the sake of simplicity, we opted for the `tail -f` solution.

Inside a loop, checking if Wordpress has been successfully deployed, we do:

```bash
if curl --fail -insecure -XGET -m10 $URL_CHECK &>/dev/null; then
  echo "The service is ready";
  tail -f -n 1 /logs/access_log /logs/error_log
  while true; do sleep 1000; done # we need this container always running 
fi
```
Afterward, these logs will be displayed by Kibana at http://127.0.0.1:5601.

>  Prometheus exporter for WP API. Put as a chart option. Create a Grafana dashboard.

A plugin based on the [Giuseppe Virzì](https://github.com/origama/wordpress-exporter-prometheus)'s work has been packed and installed (as described in a previous section). This plugin creates a `/metrics` endpoint and aggregates some metrics from the Wordpress API.
In particular, it exposes simple metrics such as the number of posts and pages. An excerpt is depicted below.

```php
...
$request->get_route()=="/metrics" ) {
        header( 'Content-Type: text/plain; charset='.get_option('blog_charset'));
        $metrics=get_wordpress_metrics();
}
...
  get_wordpress_metrics()){
  $posts=wp_count_posts();
  $n_posts_pub=$posts->publish;
  $n_posts_dra=$posts->draft;

  $result.='wp_posts_total{status="published"} '.$n_posts_pub."\n";
  $result.="# HELP wp_posts_draft_total Total number of posts published.\n";

  $result.="# TYPE wp_posts_draft_total counter\n";
  $result.='wp_posts_total{status="draft"} '.$n_posts_dra."\n";
  ...
}
```

These metrics are available at https://k8s.governify.io/wp-json/metrics.

Then, and having entered in http://127.0.0.1:3000 with the `admin` user and the generated password (as explained at `commands.sh`), we first have to add a new data source:

  ```txt
  Type: Prometheus
  URL: http://localhost:9090
  Access: Browser
  ```

Finally, we can add widget to a new dashboard using the data from the WP exporter metrics, such as `count(wp_pages_total)` or `avg(wp_users_total)`.


> Create chart repo. Add it to Kubeapps

We need to:

  1) Build the dependencies:  `helm dep build ./wordpress-training`
  2) Package our own chart: `helm package wordpress-training`
  3) Create an index: `helm repo index ./wordpress-training --url https://<your_cluster_ip>/charts`

Note we need to create a static web server to publish the `.tgz` and `yaml` files created. This can be achieved by `Github gh pages`, an `Apache` or `nginx` webservers. Nevertheless, a straightforward option, if you have a public IP, is to serve with `helm server` command:

```
helm serve --repo-path '.\static\charts\' --address '0.0.0.0:8080'
```

Finally, after entering at http://127.0.0.1:8081 with the `token` generated  (as explained at `commands.sh`), go to `Configuration -> Add Repositories -> Add App Repository` and choose a name and enter     `https://<your_cluster_ip>/charts` as URL.

That's all. Kubeapps it's easy :)

## Technical debt
  
  1) Chart documentation is quite poor, a strong refactor should be applied. Especially, focusing on incoherences and lacks explanations in some parts. Time is of the essence...   :S
  
  2) The solution RBAC-exercise is uglily hardcoded for two reasons: 1) time; 2) is it correct for a chart to create `ServiceAccount` and `ClusterRoleBinding`? I don't think so. Furthermore, `sed` of `PUT_HERE_API_PATH_TO_DEPLOYMENTS` needs to know the namespace in which the chart is deployed. By now, this info is in `values.yaml` file, but I don't think it is the right solution.
  
  3) An `inotifywait` could be used instead of the simple `tail -f` approach. Note that `error_log` file is being prompted through `stdout` instead of `sterr`. A subsequent processing in Kibana will be required.

  4) The Prometheus WP exporter could be improved a lot, but it is no the goal of the exercise though.

  5) We don't have any persistence or backup for the Grafana dashboards. Note that every dashboard definition can be imported/exported in a JSON format.
  
  6) A good start to learning new things about Helm and Operator SDK would be something like https://github.com/operator-framework/helm-app-operator-kit