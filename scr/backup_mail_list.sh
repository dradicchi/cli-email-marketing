#! /bin/sh

# Title: BackupMaillist.sh
# Package: MailMkt
# Version: 1.0
# Resume: This is script generates backups of the maillist file.

# Backup the maillist file
cp ./maillist/maillist ./maillist/bckp/maillist-"$(date)"

# Update the log file and report the work.
echo "$(date) ; BackupMaillist.sh" >> ./log/mailmkt.log
echo 'Backup the maillist file... Done!'
