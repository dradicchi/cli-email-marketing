#! /bin/sh

# Package: cli_mail_mkt
# Description: Send simple text email for an "one address by line" list (with 
#              "nohup" command support).

# Sets a start delay.
# sleep 18000s

# Creates a temporary version of the e-mai list.
cp maillist maillist_sendtxtmail.tmp

# Generates the campaignlist file, containing only non-blacklisted addresses.
echo "Generating list of addresses..."
sed '/^b;/ d' maillist_sendtxtmail.tmp > campaignlist.tmp

# While there are unprocessed addresses on e-mail list, do...
while read address

do
    # Sends a message.
    mutt -s "Replace with a valid subject" "$address" < message
    # Retuns the current mailuser.
    echo $address
		
done < campaignlist.tmp

# Cleans temporary files.
rm maillist_sendtxtmail.tmp
rm campaignlist.tmp


