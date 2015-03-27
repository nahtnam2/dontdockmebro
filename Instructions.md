#Requirements
###no sites or you'll fubar your instance#
-Fresh Ubuntu 14.04 Install
-1gb ram (2gb recommended)


  
1. Start the script with these commands. Copy paste the below:

cd /tmp; apt-get update; apt-get install git -y; git clone https://github.com/pl3bs/dontdockmebro.git; cd dontdockmebro; chmod +x install.sh; ./install.sh

2. Enter a unique password for the discourse user.
	[ YOUR PASS ]

3. Go to http://www.mandrillapp.com and signup for an acct.
 	Log into your Dashboard, and click the “settings” tab on the left toolbar
	Click, “get api key” and keep this tab open

4. When instructed, reference the tab with mandrill info & enter the appropriate values followed by the enter key
	- hostname
	- username
	- password
	- email

	
####Please note the email is used to signup and confirm your acct, granting you admin privileges. This isn't the mandrill username acct, it should be a personal email you already use, like gmail, yahoo
	
That's it! Your VPS will reboot soon, and the forums will be up and running 
	Enjoy!  
=D
