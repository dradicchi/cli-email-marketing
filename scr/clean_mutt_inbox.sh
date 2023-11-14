#! /bin/sh

# Package: cli_mail_mkt
# Description: Cleans invalid (bounced, returned and error) messages on the Mutt inbox

# Starts the cleanning.
echo "Searching for invalid messages..."

# Generates a list of the inbox messages.
ls ~/Maildir/cur | cat > inbox_list

# Sets a REGEX to find invalid messages.
regex_invalid='(^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: Delivery Status Notification \(Failure\))$|^(Subject: failure notice)$|^(Delivery has failed to these recipients or groups:)$|^(Subject: Returned mail: see transcript for details)$|^(Falha na entrega aos seguintes destinat.rios ou grupos:*)$|^(Subject: Delivery Status)$|^(Subject: Falha no Envio de e-Mail)$|^(Subject: Delivery Notification <*>)$|^(Subject: DELIVERY FAILURE: User * \(*\) not listed in Domino)$|^(Subject: ATENCAO: Sua Mensagen nao foi entregue!)$|^(Falha na entrega aos seguintes destinat.rios ou listas de distr*bui..o:)$|^(Delivery has failed to these recipients or distribution lists:)$|^(Subject: Mail delivery failed: returning message to sender)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: DELIVERY FAILURE: User *)$|^(Subject: Não Entregues: *)$|^(Subject: Non remis : *)$|^(Subject: Ticket creation failed: .-. *)$|^(Subject: Entrega de email falhou  : Retornando mensagem ao remetente)&|^(Subject: Undeliverable: *)$|^(Subject: Email nao-entregue devolvido ao remetente . Undelivered Mail Returned to Sender)$|^(... Esta é uma mensagem gerada automaticamente pela caixa postal de * Não há necessidade de respondê-la.)$|^(Subject: DELIVERY FAILURE: User * not listed in Domino*)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: Retorno de e-mail nao enviado)$|^(Subject: Não Entregues: *)$|^(Subject: Não foi poss.vel enviar: *)$|^(Subject: Non-delivery notice)$|^(Subject: Returned mail: Requested action not taken: mailbox unavailable)$|^(Subject: Returned mail: User unknown)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Falha na entrega aos seguintes destinatários ou grupos:)$|^(Subject: Não foi possível enviar: *)$|^(Subject: Não Entregues:*)$|DELIVERY FAILURE:|Falha na entrega aos seguintes destinatários ou grupos:|N.o Entregues: )'

# Sets a REGEX to find MTA's messages.
regex_mta='Mensagem autom&aacute;tica'

# Sets a REGEX to scrap email addresses.
regex_address='^((To: )(([A-Za-z0-9])+([_.-]?[A-Za-z0-9])*(@|at|%40)([A-Za-z0-9])+([_-]?[A-Za-z0-9])*(\.)([A-Za-z0-9]){1,3}(\.)([A-Za-z0-9]){1,3}))$'

# For each inbox message, do...
while read message_item inbox_list

do

	# Finds for invalid messages.
	search_message=$(grep -Eic --max-count=1 "$regex_invalid" ~/Maildir/cur/"$message_item")

        # Finds for MTA messages.
        search_mta=$(grep -Eic --max-count=1 "$regex_mta" ~/Maildir/cur/"$message_item")

	# If the message is invalid, then...
	if [ $search_message != 0 ]; then

		# Finds and saves the email address.
		grep -Ei "$regex_address" ~/Maildir/cur/"$message_item" | cat >> invalid-maillist

		# Deletes the message.
		rm -f ~/Maildir/cur/"$message_item"

		# A simple counter.
		count_messages=$(($count_messages + 1))

		# Confirms the deletion.
		echo "Deleting $message_item - Invalid"

	fi

        # If is a MTA message, then...
        if [ $search_mta != 0 ]; then

                # Delete the message.
                rm -f ~/Maildir/cur/"$message_item"

                # A simple counter.
                count_autmessages=$(($count_autmessages + 1))

                # Confirms the deletion.
                echo "Deleting $message_item - MTA"

        fi

done < inbox_list

# Finishing the work.
echo "Your inbox is clean! $count_messages /  $count_autmessages messages have been deleted."
