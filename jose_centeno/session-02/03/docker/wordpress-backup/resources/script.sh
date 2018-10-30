#!/bin/bash
DATE=$(date +%Y%m%d%H%M);
LOG_FILE=/var/log/cron.log
touch $LOG_FILE
echo "$DATE: Starting wordpress backup script" >> $LOG_FILE; 
if curl -s --head  --request GET http://localhost:80 | grep "200 OK" > /dev/null; then 
  tar -czf /backup/$DATE.tgz /pod-data/ >> $LOG_FILE 2>> $LOG_FILE;
  echo "Created /backup/$DATE.tgz" >> $LOG_FILE
else
  echo "Wordpress is not listening localhost:80" >> $LOG_FILE
fi
