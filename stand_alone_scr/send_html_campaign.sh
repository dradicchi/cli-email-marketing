#! /bin/sh

# Package: cli_mail_mkt
# Description: Sends bulk HTML message for a e-mail list using mutt

# How to use:
#
# send_html_campaign.sh <maillist:file> <message:file> <subject:string>
#


# While there are unprocessed addresses from the e-mail list, do...
while read mailuser

do
    # Send a message.
    echo $mailuser       
    mutt -e "set content_type=text/html" -s "$3" "$mailuser" < $2

done < $1

