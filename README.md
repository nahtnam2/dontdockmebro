# dontdockmebro
Scripted Discourse Installs 

Discourse Forums is next generation tech, and has up to now required either serious tech skills, or a bit of monies to get it going in the cloud. I saw a need for people to install discourse on their cheap vps, outside of the docker containers which require expensive cloud environments. 

Now you can get a working bleeding edge forum architecture without breaking the bank, or cracking open the IT books. I've done all the leg work, and installed Discourse in dozens of server environments. Now I bring to you an easy to follow scripting install to get your forums rocking without having to have an understanding of what's really going on to get it done. 

###Requirements###
-Fresh Ubuntu 14.04 Install
#/no sites or you'll fubar your instance#/
-1gb ram (2gb recommended)

OpenVZ~!~!~!
Discourse~!~
Installation
  
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
	
**Please note the email is used to signup and confirm your acct, granting you admin privileges. This isn't the mandrill username acct, it should be a personal email you already use, like gmail, yahoo...
	
That's it! Your VPS will reboot soon, and the forums will be up and running 
	Enjoy!  
=D
