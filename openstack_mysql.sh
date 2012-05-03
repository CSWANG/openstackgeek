#!/bin/bash

read -p "Enter a password to be used for the OpenStack services to talk to MySQL (users nova, glance, keystone): " service_pass

echo "#######################################################################################"
echo "Setting up MySQL now.  You will be prompted for an admin password by the setup process."
echo "#######################################################################################"
echo ""

# mysql
apt-get install -y mysql-server python-mysqldb

# make mysql listen on 0.0.0.0
sudo sed -i '/^bind-address/s/127.0.0.1/0.0.0.0/g' /etc/my.cnf

# restart
service mysql restart

# wait for restart
sleep 4 

echo "#######################################################################################"
echo "Creating OpenStack databases and users.  Use your database password when prompted."
echo "#######################################################################################"

mysql -u root -p <<EOF
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$service_pass';
GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$service_pass';
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$service_pass';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$service_pass';
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$service_pass';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$service_pass';
EOF

