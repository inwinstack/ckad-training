# Exercise I Solution

Kubernetes exercise deploying a set of WP instances connected to mariadb.

## Features

* Two versions of Wordpress, _canary_ and _production_ deployed, publicly available under an URL.
* Wordpress exposed through LoadBalancer service.
* MariaDB as wordpress backend, not publicly accesible.
* Config variables at `cm.yaml`
* Secret variables defined at `command.bash`
* Liveness/readiness probes implemented.
* Session Affinity guaranteed during two hours.

## How to run

With *kubectl configured*, do `./command.bash` to start the app. The script will print the URL to access wordpress.

## Excercise original description:

### WP + MariaDB with Canary

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

#### What to deliver

* *README.md* file with a description about the solution you developed and how to
use it. Please be as descriptive as possible and user "Markdown syntax"
* YAML/JSON files with the definitions of every requested K8s object. Templates
are provided.
* If you created your resources from the command line, attach a bash script with
the commands used to create them. Sth like:

```
#!/bin/bash

## Create ns
kubectl create ns ...

## Create secrets
kubectl create secret generic ...
```

Use the structure below on your PR To GitHub:

```
|
|-/session-01
|-/session-01/exercise-01/
|-/session-01/exercise-01/README.md
|-/session-01/exercise-01/commands.bash
|-/session-01/exercise-01/*.{json,yaml}
```

#### Tips

* Use a linter to avoid syntax errors on your YAML/JSON files

#### Notes

You need to guarantee Session Affinity when using Canary Deployments. See https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-ipvs
