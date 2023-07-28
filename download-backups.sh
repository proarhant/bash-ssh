#!/bin/bash

set -o nounset
set -o pipefail

#Option to read input from STDIN
#read -p "Enter a date (yyyy-mm-dd): " BACKUP_DATE_YYYY_MM_DD

#Cleanup when the script exits.
trap cleanup EXIT

#Usage details for the script.
usage ()
{ printf "%s
Usage: $0 [Date in yyyy-mm-dd format]

EXAMPLES

   1. To download the backup file named 2022-01-21.tar.gz from the remote server, please execute following:

      ./download-backups.sh 2022-01-21

AUTHOR
   Written by Provungshu Arhant.

";
}

#Cleanup step before exiting.
function cleanup()
{
   #Quiet exit for this current version.
   echo -e "\n`date`   [INFO] The script has exited. \n"
}

### Checking validity of the input               ###
### For instance,                                ###
###             2022-01-567 is not a valid date  ###
###             Only one argument is expected    ###

#Ensure that only one argument is passed to the script. Exit otherwise.
[[ $# -ne 1 ]] && { echo -e "\n`date`   [INFO] Invalid number of argument."; usage; exit; }

#Ensure that the argument passed is a valid date in yyyy-mm-dd format. Exit otherwise.
if ! date -d "$1" "+%Y-%m-%d" >/dev/null 2>&1; then
    echo -e "\n`date`   [INFO] Invalid date $1"; usage; exit;
fi

#At this point, we have valid date input in yyyy-mm-dd format. Let's continue...

BACKUP_DATE_YYYY_MM_DD="$1"
REMOTE_HOST="18.212.85.177"
USERNAME="evaluser"
KEY_NAME="devops-eval-evaluser.pem"
SCRIPT="pwd; ls"

NAME_PREFIX=$(date +"%Y-%m-%d" -d "$BACKUP_DATE_YYYY_MM_DD")
NAME_SUFFIX="tar.gz"

REMOTE_BACKUP_DIR="~/backups"
backupfile=$NAME_PREFIX.$NAME_SUFFIX

LOCAL_BACKUP_LOG_FILE="backup-log.log"

TARGET_FILE="wp-config.php"
DIRECTIVE_TEXT="DB_PASSWORD"
REPLACE_WITH="s5cr3t_reseT_done"

echo -e "\n`date`   [INFO] The script has started... \n"
echo -e "`date`   [CHECK] Checking existence of backup file >>> $backupfile <<< in the remote server $REMOTE_HOST ... \n"

if ssh -i $KEY_NAME -l $USERNAME $REMOTE_HOST "test -e $REMOTE_BACKUP_DIR/$backupfile"; then
   BACKUP_EXISTS=true
   sleep 1
   echo -e "`date`   [VERIFY] The backup file >>> $backupfile <<< is VERIFIED in the remote server $REMOTE_HOST\n" | tee -a $LOCAL_BACKUP_LOG_FILE
   echo -e "`date`   [INFO] DOWNLOADING >>> $backupfile <<< from the remote server $REMOTE_HOST ... \n"

   #Download the backup file and then check if the file exists in local machine.
   scp -i $KEY_NAME -q $USERNAME@$REMOTE_HOST:$REMOTE_BACKUP_DIR/$backupfile .
   [ -f "./$backupfile" ] && { echo -e "`date`   [VERIFIED & DOWNLOADED] The backup for the date $NAME_PREFIX has been verified and downloaded. \n" \
      | tee -a $LOCAL_BACKUP_LOG_FILE; } || echo "[ERROR] Download of >>> $backupfile <<< was NOT successful. | tee -a $LOCAL_BACKUP_LOG_FILE"

  #At this stage we have the backup file downloaded in current local directory.
  #Extract files from the backup, then replace password in the wp-config.php file
  tar -xf $backupfile

  echo -e "`date`   [INFO] Replace the password for DB_PASSWORD... \n"
  #sed -i "/DB_PASSWORD/s/'[^']*'/'New_password'/2" wp-config.php
  sed -i "/$DIRECTIVE_TEXT/s/'[^']*'/'$REPLACE_WITH'/2" $NAME_PREFIX/$TARGET_FILE

  #Recreate the backup archive (locally)
  tar -czf $backupfile $NAME_PREFIX/

else
   BACKUP_EXISTS=false
   echo -e "`date`   [ERROR] The backup file >>> $backupfile <<< does NOT exist in the remote server $REMOTE_HOST. \n" | tee -a $LOCAL_BACKUP_LOG_FILE
fi

echo -e "`date`   [INFO] Completed. The log entries have been appended to `pwd`/$LOCAL_BACKUP_LOG_FILE \n"
