#! /bin/sh

# Package: cli_mail_mkt
# Resume: Displays a menu of options/commands.

# Starts an infinite loop!
while :

do

    # Displays a list of options.
    echo "

    ============ MailMkt Control Panel ============

    Type the respective number (or letter) to execute a function:

    [1] Add new e-mail addresses;
    [2] Add new blacklisted addresses;
    [3] Send a simple text campaign;
    [4] Process bounced mail;
    [B] Backup the e-mail list file;
    [0] Exit.

    ===============================================

    "
    
    # Read a option.
    read -p 'Number of option: ' menu_option

    

    # Case "menu_option" is... , do...
    case "$menu_option" in

        1) ./scr/add_new_addresses.sh;;
        2) ./scr/blacklist_addresses.sh;;
        3) nohup ./scr/send_txt_campaign_nohup.sh;;
        4) ./scr/clean_mutt_inbox.sh;;
        B) ./scr/backup_mail_list.sh;;
        0) exit;;
        *) echo 'Invalid Option. Try again!';;

    esac

done
