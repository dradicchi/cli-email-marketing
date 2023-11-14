#! /bin/sh

# Package: cli_mail_mkt
# Description: Sends bulk text message for a e-mail list using mutt

# How to use:
#
# send_txt_campaign.sh <maillist:file> <message:file> <subject:string>
#


# While there are unprocessed addresses from the e-mail list, do...
while read mailuser

do
    # Send a message.
    echo $mailuser       
    mutt -s "$3" "$mailuser" < $2

done < $1

