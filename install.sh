#Load closest mirrors

sed -i '1ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse' /etc/apt/sources.list;
sed -i '2ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse' /etc/apt/sources.list;
sed -i '3ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse' /etc/apt/sources.list;
sed -i '4ideb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse' /etc/apt/sources.list;

#update and upgrade

apt-get update;
apt-get upgrade -y;

#install dependencies

apt-get install git ufw redis-server nano fail2ban imagemagick curl sudo postgresql-9.3 postgresql-contrib-9.3 build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk -y;

#make discourse sudoer

sed -i '/ALL=(ALL:ALL) ALL/adiscourse    ALL=(ALL:ALL) ALL' /etc/sudoers;

read -p "Enter a Password for the Discourse User " psss;
yes "$psss" | sudo adduser --shell /bin/bash --gecos 'Discourse application' discourse;
sudo install -d -m 755 -o discourse -g discourse /var/www/discourse;


sudo -u postgres createuser -s discourse;

#install rvm

su discourse <<'EOF'

sudo ln -sf /proc/self/fd /dev/fd
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
\curl -s -S -L https://get.rvm.io | bash -s stable
. ~/.rvm/scripts/rvm
rvm install 2.1.3
rvm use 2.1.3 default

#install gems and discourse

sudo git clone https://github.com/discourse/discourse.git -b tests-passed --single-branch /var/www/discourse
cd /var/www/discourse
gem install bundler
cd  /var/www
sudo chown discourse:discourse discourse -R
cd discourse
bundle install
exit

EOF
