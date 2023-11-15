#! /bin/sh

# Resume: Lists contacts that opened a message but doesn't clicked on.


# While there contacts on opened.csv, does
while read contact

do
	
	# Extracts the email of the CSV file
	email=$(echo $contact | cut -d, -f 2)
	
	# If email address doesn't exists in clicked.csv, catch it
	if [ $(grep -Eic $email clicked.csv) -ne 1 ]; then echo $contact >> opened-not-clicked.csv; fi;
		
done < opened.csv

echo "Its done!"
