#!/bin/bash
sudo yum install java -y
sudo yum install git -y
sudo yum install maven -y

if [ -d "addressbook"]
then 
 echo "repo is cloned and exits"
 cd /home/ec2-user/addressbook 
 git pull origin b1 
else 
 git clone  https://github.com/PraveenKumarDova/addressbook.git

fi

cd /home/ec2-user/addressbook

mvn package 