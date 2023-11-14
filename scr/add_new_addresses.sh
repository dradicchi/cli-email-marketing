#! /bin/sh

# Package: cli_mail_mkt
# Resume: Adds new addresses in the e-mail list file.

# Reads the path for the file containing new e-mail addresses.
read -p 'Enter the path of the file containing new e-mail addresses: ' new_addresses

# Reads the path for the e-mail list file.
read -p 'Enter the path of the maillist file: ' email_list

# Creates a temporary version of the e-mail list.
cp "$email_list" maillist_addmaillist.tmp

# Stores the current number of addresses from the e-mail list.
count_addresses=$(wc -l maillist_addmaillist.tmp | cut -d " " -f 1)

# To each potential new address, do...
echo 'Checking potential new addresses...'
while read n_address 

do
	# "is_new_address" is zero for new addresses.
	is_new_address=$(grep -Eic "^(B;)?($n_address)$" maillist_addmaillist.tmp)

	# If it's really new, then...
	if [ $is_new_address = 0 ]; then

		# Adds the new email in a temporary version of the e-mail list.
		echo "Adding -> $n_address"	
		echo $n_address >> maillist_addmaillist.tmp

	fi

done < "$new_addresses"

# Sorts the maillist-addmaillist.tmp.
sort -u maillist_addmaillist.tmp > maillist_addmaillist-ordened.tmp

# Counts the addresses added.
total_addresses=$(wc -l maillist_addmaillist_ordened.tmp | cut -d " " -f 1)
count_new_addresses=$(($total_addresses - $count_addresses))

# Generates a updated e-mail list file and removes the temporary files.
cp maillist_addmaillist-ordened.tmp "$email_list"
rm maillist_addmaillist.tmp maillist_addmaillist_ordened.tmp

# Updates the log file.
# echo "$(date) ; add_new_addresses.sh - $count_new_addresses new added addresses" >> ./log/mailmkt.log

# Report the work.
echo "Were added $count_new_addresses new emails. Now, the maillist contains $total_addresses addresses."

