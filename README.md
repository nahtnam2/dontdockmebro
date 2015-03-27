# dontdockmebro
Scripted Discourse Installs 

Discourse Forums is next generation tech, and has up to now required either serious tech skills, or a bit of monies to get it going in the cloud. I saw a need for people to install discourse on their cheap vps, outside of the docker containers which require expensive cloud environments. 

Now you can get a working bleeding edge forum architecture without breaking the bank, or cracking open the IT books. I've done all the leg work, and installed Discourse in dozens of server environments. Now I bring to you an easy to follow scripting install to get your forums rocking without having to have an understanding of what's really going on to get it done. 

OpenVZ~!~!~!
Discourse~!~
Installation
  
1. Get the files with this command:
	git clone https://github.com/pl3bs/dontdockmebro.git

2. start the files with this command
	chmod +x install.sh ; ./install.sh

3. Enter a unique password into the first terminal and press enter to finish the first script.
	[ YOUR PASS ]

4. Go to http://www.mandrillapp.com and signup for an acct.
 	Log into your Dashboard, and click the “settings” tab on the left toolbar
	Click, “get api key” and keep this tab open

5. When instructed, reference the tab with mandrill info & enter the appropriate values followed by the enter key
	

	That's it! Your VPS will reboot soon, and the forums will be up and running 
	Enjoy!  

=D
