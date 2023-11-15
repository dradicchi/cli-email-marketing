#! /bin/sh

# Description: A script to test REGEX for email content


echo "Checking inbox..."
echo "Generating a list for inbox messages..."


ls ~/Maildir/cur | cat > inbox_list

message_num=$(wc -l inbox_list)

echo "There are $message_num messages on inbox."

regex_test='(^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: Delivery Status Notification \(Failure\))$|^(Subject: failure notice)$|^(Delivery has failed to these recipients or groups:)$|^(Subject: Returned mail: see transcript for details)$|^(Falha na entrega aos seguintes destinat.rios ou grupos:*)$|^(Subject: Delivery Status)$|^(Subject: Falha no Envio de e-Mail)$|^(Subject: Delivery Notification <*>)$|^(Subject: DELIVERY FAILURE: User * \(*\) not listed in Domino)$|^(Subject: ATENCAO: Sua Mensagen nao foi entregue!)$|^(Falha na entrega aos seguintes destinat.rios ou listas de distr*bui..o:)$|^(Delivery has failed to these recipients or distribution lists:)$|^(Subject: Mail delivery failed: returning message to sender)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: DELIVERY FAILURE: User *)$|^(Subject: Não Entregues: *)$|^(Subject: Non remis : *)$|^(Subject: Ticket creation failed: .-. *)$|^(Subject: Entrega de email falhou  : Retornando mensagem ao remetente)&|^(Subject: Undeliverable: *)$|^(Subject: Email nao-entregue devolvido ao remetente . Undelivered Mail Returned to Sender)$|^(... Esta é uma mensagem gerada automaticamente pela caixa postal de * Não há necessidade de respondê-la.)$|^(Subject: DELIVERY FAILURE: User * not listed in Domino*)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Subject: Retorno de e-mail nao enviado)$|^(Subject: Não Entregues: *)$|^(Subject: Não foi poss.vel enviar: *)$|^(Subject: Non-delivery notice)$|^(Subject: Returned mail: Requested action not taken: mailbox unavailable)$|^(Subject: Returned mail: User unknown)$|^(Subject: Undelivered Mail Returned to Sender)$|^(Falha na entrega aos seguintes destinatários ou grupos:)$|^(Subject: Não foi possível enviar: *)$|^(Subject: Não Entregues:*)$|DELIVERY FAILURE:|Falha na entrega aos seguintes destinatários ou grupos:|N.o Entregues: )'

echo "Testing the regex..."

while read message_item inbox_list

do

        
        search_message=$(grep -Eic --max-count=1 "$regex_test" ~/Maildir/cur/"$message_item")

        
        if [ $search_message != 0 ]; then

                
                count_test=$(($count_test + 1))

        fi

done < inbox_list


echo "The regex found $count_test messages."

