#! /bin/sh

# Resume: This program stamping email addresses with a "B" tag, preventing them from receiving messages.

# Read the name of the file containing the new blacklisted addresses.
read -p 'Enter the name of the file containing new blacklisted addresses (the file must be in the same directory as the script): ' newBlackList

# Create a temporary version of the maillist.
cp maillist maillist-blacklist.tmp

# Store the current number of blacklisted addresses.
countInitialBlacklisted=$(grep -Eic "^(B;)*$" maillist-blacklist.tmp)

# Create a concatenated set of "address & command" for each blacklisted address.
# Model: "/B;/! { /address01/ s/^/B;/; } ; /B;/! { /address02/ s/^/B;/; } ; ..."
echo "Preparing Addresses..."
set_blist=$(sed 's/^/\/B;\/! { \// ; s/$/\/ s\/^\/B;\/; } ; /' "$newBlackList")

# Stamp a "B" on each blacklisted address and generate the updated maillist file.
echo "Labeling blacklisted addresses..."
sed "$set_blist" maillist-blacklist.tmp > maillist

# Count the addresses added on blacklist
countTotalBlacklisted=$(grep -Eic "^(B;)*$" maillist-blacklist.tmp)
countNewBlackListed=$(($countTotalBlacklisted - $countInitialBlacklisted))
rm maillist-blacklist.tmp

# Update the log file.
echo "$(date) ; listmanager-blacklist - $countNewBlackListed new blacklisted addresses" >> mailmkt.log

# Report the work.
echo "Were blacklisted $countNewBlackListed addresses. Now, maillist contains $countTotalBlacklisted emails."
