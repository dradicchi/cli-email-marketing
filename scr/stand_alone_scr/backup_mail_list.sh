#! /bin/sh

# Package: cli_mail_mkt
# Description: To backup CLI Mail Mkt files.

rsync -ravz --progress -e "ssh -p 27010" /home/<REPLACE_USER>/cli_mail_mkt/ sysadmin@<REPLACE_IP_HERE>:/home/sysadmin/cli_mail_mkt/

scp -vC -P 27010 /home/<REPLACE_USER>/cli_mail_mkt/maillist sysadmin@<REPLACE_IP_HERE>:/home/sysadmin/cli_mail_mkt/maillist
