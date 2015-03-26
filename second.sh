

#!/bin/bash
sudo ln -sf /proc/self/fd /dev/fd;
curl -sSL https://rvm.io/mpapis.asc | gpg --import -;
\curl -s -S -L https://get.rvm.io | bash -s stable;
. ~/.rvm/scripts/rvm;
rvm install 2.0.0;
rvm use 2.0.0 ^▒default;
sudo git clone git://github.com/discourse/discourse.git /var/www/discourse;
cd /var/www/discourse;
gem install bundler;
cd  /var/www;
sudo chown discourse:discourse discourse -R;
cd discourse;
bundle install --deployment --without test;
cd /var/www/discourse/config;
cp /tmp/dontdockmebro/startup.sh /var/www/discourse/startup.sh;
cp discourse_quickstart.conf discourse.conf;
read -p "Ready to Configure discourse.conf...[Press ENTER]";
cd /var/www/discourse;
createdb discourse_prod;
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake db:migrate;
RUBY_GC_MALLOC_LIMIT=90000000 RAILS_ENV=production bundle exec rake assets:precompile;
mkdir /var/www/discourse/tmp/pids;
sudo initctl start disc;
sudo reboot;

