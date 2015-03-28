sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse' /etc/apt/sources.list;
sed -i '2ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list;
sed -i '3ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list;
sed -i '4ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list;
apt-get update;
apt-get upgrade -y;
apt-get install nano fail2ban redis-server curl sudo postgresql-9.3 postgresql-contrib-9.3 build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk -y ;
cd /etc/fail2ban;
cp jail.conf jail.local;
service fail2ban start;
sed -i '11i@reboot root bash /var/www/discourse/startup.sh' /etc/crontab;
sed -i '/ALL=(ALL:ALL) ALL/adiscourse    ALL=(ALL:ALL) ALL' /etc/sudoers;
read -p "Enter a Password for the Discourse User " psss;
yes "$psss" | sudo adduser --shell /bin/bash --gecos 'Discourse application' discourse;
sudo install -d -m 755 -o discourse -g discourse /var/www/discourse;
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
su discourse <<'ABC'
sudo ln -sf /proc/self/fd /dev/fd
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -s -S -L https://get.rvm.io | bash -s stable
. ~/.rvm/scripts/rvm
rvm install 2.0.0
rvm use 2.0.0 default
sudo git clone git://github.com/discourse/discourse.git /var/www/discourse
cd /var/www/discourse
gem install bundler
cd  /var/www
sudo chown discourse:discourse discourse -R
cd discourse
bundle install --deployment --without test
cp /tmp/dontdockmebro/startup.sh /var/www/discourse/startup.sh
cd /var/www/discourse/config
cp discourse_quickstart.conf discourse.conf
read -p "Please Configure discourse.conf File "
sed -i "/^smtp_address/ s/$/ smtp.mandrillapp.com /" discourse.conf
sed -i 's/25/587/g' discourse.conf
read -p "Enter the name of your domain [ex: www.webeindustry.com] " domain
sed -i "s/"discourse.example.com"/$domain/g" discourse.conf
read -p "Enter your MandrillApp Username [ex: admin@webeindustry.com] " uname
sed -i "/^smtp_user_name/ s/$/ $uname/g" discourse.conf
read -p "Enter your MandrillApp API Key [ex: ytCARGJVKfLJs3x6MQZqw] " API
sed -i "/^smtp_password/ s/$/ $API/g" discourse.conf
read -p "Enter the email address you use to register your account [ex: mail@webeindustry.com] " mail
sed -i "/^developer_email/ s/$/ $mail/g" discourse.conf
cd /var/www/discourse
createdb discourse_prod
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake db:migrate
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:precompile
mkdir /var/www/discourse/tmp/pids
ABC
cd /var/www/discourse/config;
cp unicorn_upstart.conf /etc/init/disc.conf;
cp nginx.global.conf /etc/nginx/conf.d/local-server.conf;
echo "Shutting Down to Finalize Installation";
#sudo reboot;
