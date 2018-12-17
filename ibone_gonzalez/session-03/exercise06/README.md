# Kubeapps

- Install kubeapps

`helm repo add bitnami https://charts.bitnami.com/bitnami`

`helm install --name kubeapps --namespace kubeapps bitnami/kubeapps`

- Packaging the deps

`helm dep build .\exercise01\`

- Packaging the chart

`helm package -d . .\exercise01\`

- Creating an index

`helm repo index . --url https://127.0.0.1:6446/charts`

- Serving our chart

`helm serve --repo-path '.\static\charts\' --address '127.0.0.1:8080'`

- Visit http://127.0.0.1:8080 to use see your local chart.
