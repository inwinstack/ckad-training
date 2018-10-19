# Solution for Session 2 exercise 2

A command.sh script is provided to create all the elements needed.

After executing command.sh script, execute the job creation:

`kubectl create -f mariadb-backup-job.yaml`

If you access 

## Exercise II

Job for backing up a WordPress Database
- You can use the WP + MariaDB deployment from exercise 1
- Use a volume for the backup
- Use mysqldump command (find a container or build your own one). You may need to create a docker account for uploading your containers

### Solution notes:

Currently using a PVC, but also defined a hostPath volume.
To use the hostPath volume:
- You need to create /home/bitnami/bck path and give permissions
- change volumeMount.name field to mariadb-backup-vol-host

It uses same MariaDB image to execute mysqldump command.
Other solution could be using https://github.com/camilb/kube-mysqldump-cron 


