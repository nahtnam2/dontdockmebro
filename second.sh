
#!/bin/bash
sudo ln -sf /proc/self/fd /dev/fd;
curl -sSL https://rvm.io/mpapis.asc | gpg --import -;
\curl -s -S -L https://get.rvm.io | bash -s stable;
. ~/.rvm/scripts/rvm;
rvm install 2.0.0;
rvm use 2.0.0 default;
sudo git clone git://github.com/discourse/discourse.git /var/www/discourse;
cd /var/www/discourse;
gem install bundler;
cd  /var/www;
sudo chown discourse:discourse discourse -R;
cd discourse;
bundle install --deployment --without test;
cd /var/www/discourse/config;
sudo cp /tmp/dontdockmebro/startup.sh /root/startup.sh;
sudo cp nginx.global.conf /etc/nginx/conf.d/local-server.conf;
sudo cp discourse_quickstart.conf discourse.conf;
sudo cp unicorn_upstart.conf /etc/init/disc.conf;
#sed -i "/^smtp_address/ s/$/ smtp.mandrillapp.com /" discourse.conf;
#sed -i 's/25/587/g' discourse.conf;
#read -p "Enter the name of your domain [ex: www.webeindustry.com] " domain;
#sed -i "s/"discourse.example.com"/$domain/g" discourse.conf;
#read -p "Enter your MandrillApp Username [ex: admin@webeindustry.com] " uname;
#sed -i "/^smtp_user_name/ s/$/$uname/g" discourse.conf;
#read -p "Enter your MandrillApp API Key [ex: ytDARGJVKfLJs3a6GQZqw] " API;
#sed -i "/^smtp_password/ s/$/$API/g" discourse.conf;
read -p "Enter the email address you use to register your account [ex: mail@webeindustry.com] " mail;
#sed -i "/^developer_email/ s/$/$mail/g" discourse.conf;
cd /var/www/discourse;
createdb discourse_prod;
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake db:migrate;
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:precompile;
mkdir /var/www/discourse/tmp/pids;
sudo reboot;

