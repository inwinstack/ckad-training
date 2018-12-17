# Exercise 03

## Part 1

Following the exercise instructions, the system is deployed by adding a sidecar.

## Part 2

After that we have to change the imagen:
kubectl delete -f wordpress-deployment.yaml
kubectl create -f wordpress-javsalgar-deployment.yaml

In order to solve the problem caused by the change of imagen we use an initContainer.

To solve MARIADB_HOST environment variable does not work, it is always accessing localhost, we open up that route with the command "socat ".
