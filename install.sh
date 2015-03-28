#!/bin/bash

#Load closest mirrors

sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse' /etc/apt/sources.list;
sed -i '2ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list;
sed -i '3ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list;
sed -i '4ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list;

cd /tmp;


#update and upgrade

apt-get update;
apt-get upgrade -y;

#install dependencies

apt-get install git nano fail2ban imagemagick redis-server curl sudo postgresql-9.3 postgresql-contrib-9.3 build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk -y;

#configure fail2ban

cd /etc/fail2ban;
cp jail.conf jail.local;

#start fail2ban & redis

service fail2ban start; service redis-server start;

#update crontab for discourse auto-start

sed -i '11i@reboot root bash /var/www/discourse/startup.sh' /etc/crontab;

#make discourse sudoer

sed -i '/ALL=(ALL:ALL) ALL/adiscourse    ALL=(ALL:ALL) ALL' /etc/sudoers;

read -p "Enter a Password for the Discourse User " psss;
yes "$psss" | sudo adduser --shell /bin/bash --gecos 'Discourse application' discourse;
sudo install -d -m 755 -o discourse -g discourse /var/www/discourse;

#get dontdockmebro
cd/tmp;
git clone https://github.com/pl3bs/dontdockmebro.git;

#get latest nginx

yes | sudo apt-get remove '^nginx.*$';
cat << 'EOF' | sudo tee /etc/apt/sources.list.d/nginx.list
deb http://nginx.org/packages/ubuntu/ trusty nginx
deb-src http://nginx.org/packages/ubuntu/ trusty nginx

EOF

curl http://nginx.org/keys/nginx_signing.key | sudo apt-key add -;
sudo apt-get update && sudo apt-get -y install nginx;
cp /tmp/dontdockmebro/disco.conf /etc/nginx/conf.d/disco.conf;
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.disabled;
mkdir /var/nginx;
service nginx restart;
sudo -u postgres createuser -s discourse;

#install rvm

su discourse <<'EOF'

sudo ln -sf /proc/self/fd /dev/fd
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -s -S -L https://get.rvm.io | bash -s stable
. ~/.rvm/scripts/rvm
rvm install 2.0.0
rvm use 2.0.0 default

#install ruby and discourse

sudo git clone git://github.com/discourse/discourse.git /var/www/discourse
cd /var/www/discourse
gem install bundler
cd  /var/www
sudo chown discourse:discourse discourse -R
cd discourse
bundle install --deployment --without test
cp /tmp/dontdockmebro/startup.sh /var/www/discourse/startup.sh

EOF

cd /var/www/discourse/config;
sudo cp discourse_quickstart.conf discourse.conf;
sed -i "/^smtp_address/ s/$/ smtp.mandrillapp.com /" discourse.conf;
sed -i 's/25/587/g' discourse.conf;
read -p "Enter the name of your domain [ex: www.webeindustry.com] " domain;
sed -i "s/"discourse.example.com"/$domain/g" discourse.conf;
read -p "Enter your MandrillApp Username [ex: admin@webeindustry.com] " uname;
sed -i "/^smtp_user_name/ s/$/ $uname/g" discourse.conf;
read -p "Enter your MandrillApp API Key [ex: ytCARGJVKfLJs3x6MQZqw] " API;
sed -i "/^smtp_password/ s/$/ $API/g" discourse.conf;
read -p "Enter the email address you use to register your account [ex: mail@webeindustry.com] " mail;
sed -i "/^developer_email/ s/$/ $mail/g" discourse.conf;

#init data

su discourse <<'EOF'

cd /var/www/discourse
createdb discourse_prod
/bin/bash --login
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake db:migrate
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:precompile
mkdir /var/www/discourse/tmp/pids

EOF

#final config tweaks 

cd /var/www/discourse/config;
sed -i '27iexport UNICORN_SIDEKIQS=1' unicorn_upstart.conf;
cp unicorn_upstart.conf /etc/init/disc.conf;
cp nginx.global.conf /etc/nginx/conf.d/local-server.conf;
echo "Shutting Down to Finalize Installation";

#reboot to clean up and auto-start

sudo reboot;
