# Solution for Session 3 exercises

## Exercise I

A WordPress Chart that allow setting:
- The number of WordPress replicas 
- Ingress (with TLS support)
- NetworkPolicies
- Persistence
- Choosing between MySQL or MariaDB as the backend
- MySQL dump backup CronJob
- Providing a set of plugins to install at deployment time

### Solution notes

Based on current stable/wordpress chart that support most of requested functionalities. I've done that because I have no much time and:
- I want to focus on some requirements I think are more valueable, 
- I think it is more usual to modify existent charts than creating new ones).

To get current wordpress chart

./helm fetch stable/wordpress -d exercise-01/charts-stable-wordpress

*Choosing between MySQL or MariaDB as the backend*

Once the new dependency (mysql) has been added on requirements.yaml file:
- Add bitnami charts repo:
`helm repo add bitnami https://charts.bitnami.com/bitnami`
- Get mysql dependency
`helm dependency update`

Get mysql chart is necessary to check the setup.

Then, I have:
- Added some mysql options to values.yaml to be used from templates
- Modified templates/deployment.yaml in order to use mysql when enabled.
- Modified helpers.tpl to add some functions.

*_TODO:_*
- Add comments 
- I have a problem (reported on slack) with helpers.


*Providing a set of plugins to install at deployment time*

I have added a initContainer to wordpress that will download and install the plugins.

*MySQL dump backup CronJob* _Pending_

Like on session02-exercise02:
- Create a PVC that will store the backups
- Create a cronJob that executes mysqldump and store the result on the previous PVC

Other option:
- Create a PVC that will store the backups
- Create a cronJob that mount the backups-PVC and the MYSQL-data-volume and make a copy of the MySQL-data-volume on the backups one.

