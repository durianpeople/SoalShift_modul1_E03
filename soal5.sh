#!/bin/bash

cat /var/log/syslog | awk '$0 !~ /sudo/ {print}' | awk 'IGNORECASE=1; /cron/ {print}' | awk 'NF < 12' > /home/akmal/modul1

#crontab 2-30/6 * * * * /home/akmal/Documents/Praktikum1_5.sh
