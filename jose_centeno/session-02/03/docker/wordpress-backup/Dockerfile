# docker build --tag jica/wordpress-backup:1.0 .

FROM ubuntu:latest
# Install curl and cron
RUN apt-get update && apt-get -y install curl cron

# Add crontab file in the cron directory
ADD resources/crontab /etc/cron.d/wordpress-backup-cron
ADD resources/script.sh /

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/wordpress-backup-cron; \
  chmod 0755 /script.sh

# Create the log file to be able to run tail
RUN touch /var/log/cron.log; \
  echo "Starting wordpress backup log" >> /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log