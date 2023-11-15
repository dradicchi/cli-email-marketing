#! /bin/sh


# Resume: This script generates a email list from a list of domain names 
#         provided as input, using the Google Search.

# Backup the maillsit file.
echo "Starting the script..."

# Defines a regular expression for locate domains
regex='@([A-Za-z0-9])+([.-]?[A-Za-z0-9])*(.com|.net|.ind|.srv)(.br)?'

# Generates a copy of maillist file.
cp maillist maillist-tmp

# Filters the domains.
echo "Filtering the domains..."
grep -Eio "$regex" maillist-tmp | sort -u | cat > domainlist

# counts the domains.
count_domain=$(wc -l domainlist | sed '/ domainlist/ s///')
echo "Were found $count_domain domains."

# Acquires the name of the result file.
read -p "Enter the name of the new address list:" addlist

# Starts the search.
echo "Starting the search..."

# While there are unprocessed domains, do...
while read domain domainlist

do
	# What is the domain of time?
	echo "Searching $domain ..."
	
	# Sets an initial page for a search
	search_page=0

	# Generates a initial search path
	search_path='http://www.google.com.br/search?hl=pt-BR&num=100&start='"$search_page"'&q="'"$domain"'"'

	# Defines a regular expression for locate emails
	regex_mail='(^|[ \t]|[:;.])([A-Za-z0-9])+([_.-]?[A-Za-z0-9])*(@|at|%40)'"$domain"'([ \t]|[:;,]|[.][ \t]|[.]?$)'

	# Defines regular expressions to identify pages
	regex_pages_1='(Anterior([ \t][0-9])+|([0-9][ \t])+Mais)'
	regex_pages_2='(([ \t][0-9])+|([0-9][ \t])+)'
	
	# Counts the number of pages
	counter_pages=$(links -dump "$search_path" | grep -Eio "$regex_pages_1" | grep -Eio "$regex_pages_2" | wc -w)

	# If "counter_pages == 0", increases "counter_pages" on "1"
	if [ $counter_pages = 0 ]; then counter_pages=$(($counter_pages + 1)); fi; echo "Search returned $counter_pages pages."
	
	# For each page, does...
	for counter in $(seq 1 1 $counter_pages)

	do
		
		# Locates and saves valid emails on "maillist" file
		links -dump "$search_path" | grep -Eio "$regex_mail" | sort -u >> addlist-tmp; echo $search_path
		
		# Updates $search_page and...
		search_page=$(($search_page + 100))

		# ...updates the search path
		search_path='http://www.google.com.br/search?hl=pt-BR&num=100&start='"$search_page"'&q="'"$domain"'"'
		
		# Calms the Google!
		sleep 30s

	done
		
done < domainlist

# Finishes the search.
echo "Finishing the search..."

# Defines a regular expression for locate clean e-mails.
regex='([A-Za-z0-9])+([_.-]?[A-Za-z0-9])*@([A-Za-z0-9])+([.-]?[A-Za-z0-9])*(.com|.net|.ind|.srv)(.br)?'

# Cleans the addresses.
echo "Cleaning addresses..."
grep -Eio "$regex" addlist-tmp | sort -u >> "$addlist"

# Removes TMP files.
rm addlist-tmp maillist-tmp

# counts the addresses.
count_addresses=$(wc -l "$addlist" | sed "/ $addlist/ s///")

# Updates the log file.
echo "$(date) ; listmanager-genmaillist" >> mailmkt.log

# Finishes the work.
echo "Were searched $count_addresses emails, from $count_domain domains. To add these addresses in maillist file, please use the 'listmanager-addmail' script."




