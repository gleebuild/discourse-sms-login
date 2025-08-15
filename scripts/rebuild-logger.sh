#!/bin/bash
# discourse-sms-login/scripts/rebuild-logger.sh
LOG_DIR="/var/discourse/shared/standalone/log"
TIMESTAMP=$(date +"%Y-%m-%d %T")

echo "[$TIMESTAMP] Rebuild STARTED by $USER" >> $LOG_DIR/rebuild.log
./launcher rebuild app 2>&1 | tee -a $LOG_DIR/rebuild.log
echo "[$TIMESTAMP] Rebuild COMPLETED" >> $LOG_DIR/rebuild.log