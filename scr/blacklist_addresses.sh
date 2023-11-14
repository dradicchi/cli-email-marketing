#! /bin/sh

# Package: cli_mail_mkt
# Description: Blacklists a list of addresses.

# Reads the path for the file containing the new blacklisted e-mail addresses.
read -p 'Enter the path of the file containing the new blacklisted e-mail addresses: ' invalid_addresses

# Reads the path for the e-mail list file.
read -p 'Enter the path of the e-mail list file: ' email_list

# Creates a temporary version for the maillist.
cp "$email_list" maillist_blackmaillist.tmp

# Stores the current number of blacklisted e-mails.
count_invalid_addresses=$(grep -Eic "^(B;)" maillist_blackmaillist.tmp)

# To each new invalid address, do...
# This routine supports to blacklist an unique address or a entire domain.
echo 'Marking addresses as blacklisted...'
while read b_address 

do    

    # Is "b_address" a domain?
    is_domain=$(echo "$b_address" | grep -Eic '^@')    

    # If it is a domain, then... else...
    if [ $is_domain = 1 ]; then

        # Marks all addresses from the domain with an initial "B;" string.
        echo "Marking Domain -> $b_address"
        sed "/B;/! { /$b_address/ s/^/B;/ }" maillist_blackmaillist.tmp > maillist_blackmaillist-tmp.tmp    

        # Updates "maillist-blackmaillist.tmp".
        cp maillist_blackmaillist-tmp.tmp maillist_blackmaillist.tmp
    
    else

        # Is there a "b_address" in the e-mail list file?
        is_address=$(grep -Eic "^(B;)?($b_address)$" maillist_blackmaillist.tmp)

        # If there is not, then... else...
        if [ $is_address = 0 ]; then

            # Logs the not founded address.
            echo "$b_address" >> not_founded_addresses.log
    
        else

            # Marks the address with an initial "B;" string.
            echo "Marking -> $b_address"
            sed "/B;/! { /$b_address/ s/^/B;/ }" maillist_blackmaillist.tmp > maillist_blackmaillist_tmp.tmp    

            # Updates "maillist-blackmaillist.tmp".
            cp maillist_blackmaillist_tmp.tmp maillist_blackmaillist.tmp

        fi


    fi

done < "$invalid_addresses"

# Sorts the maillist-blackmaillist.tmp.
sort -u maillist_blackmaillist.tmp > maillist_blackmaillist_ordened.tmp

# Counts the addresses marked.
total_invalid_addresses=$(grep -Eic "^(B;)" maillist_blackmaillist_ordened.tmp)
count_blacklisted_addresses=$(($total_invalid_addresses - $count_invalid_addresses))

# Counts not found addresses.
not_founded_addresses=$(wc -l not_founded_addresses.log | cut -d " " -f 1)

# Generates a updated e-mail list file and removes the temporary files.
cp maillist_blackmaillist_ordened.tmp "$email_list"
rm maillist_blackmaillist.tmp maillist_blackmaillist_ordened.tmp maillist_blackmaillist_tmp.tmp

# Updates the log file.
# echo "$(date) ; blacklist_address.sh - $count_blacklisted_addresses blacklisted addresses" >> ./log/mailmkt.log

# Reports the results.
echo "Were blacklisted $count_blacklisted_addresses new emails. Now, the maillist contains $total_invalid_addresses addresses. ATENTION: $not_founded_addresses addresses were not found. See notfoundaddresses.log file!"

