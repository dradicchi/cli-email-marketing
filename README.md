# cli_email_marketing

A bash command line app to email marketing campaigns. 
The project uses a local Postfix SMTP implementation and the Mutt email client to send campaigns and handle bounced responses.

FEATURES:
- Very light and powerful - It is capable of sending and processing +1mm of messages per day when implementd with a 1vCPU VPS and 2Gb of RAM.
- CLI control panel;
- Manages new addresses and lists;
- Processes blacklisted addresses, including entire domains;
- Processes invalid/error recipients (bounced emails);
- Sends bulk messages with HTML and TXT;

COMMENTS:
- The project was started in 2009 and has not been updated since 2012.
- The routines were written with an imperative and non-procedural approach (with many side effects), considering the scenario of using with a exclusive baremetal server (later, a VPS) for running campaigns.

