#Instructions
On a fresh 14.04LTS install run this command 
setup a password for the discourse user when asked

bash <(wget -qO- https://raw.githubusercontent.com/pl3bs/dontdockmebro/developer/install.sh)

after script completes run these commands:

redis-server
*ctrl-c to go back to prompt

su discourse
. ~/.rvm/scripts/rvm
cd /var/www/discourse
bundle exec rake db:create db:migrate db:test:prepare
bundle exec rails server



In putty go to ssh > tunnels section and add source port 3000 and destination 127.0.0.1:3000

go to localhost:3000 to visit discourse install

** for mail support 
