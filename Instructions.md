#Instructions
On a fresh 14.04LTS install run this command 
setup a password for the discourse user when asked

bash <(wget -qO- https://raw.githubusercontent.com/pl3bs/dontdockmebro/developer/install.sh)

In putty go to ssh > tunnels section and add source port 3000 and destination 127.0.0.1:3000

After script completes go to localhost:3000 to visit discourse install
