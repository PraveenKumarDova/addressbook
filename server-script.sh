#!/bin/bash
#sudo yum install java -y
sudo yum install git -y
#sudo yum install maven -y
sudo yum install docker -y
sudo systemctl start docker

if [ -d "addressbook"]
then 
 echo "repo is cloned and exits"
 cd /home/ec2-user/addressbook 
 git pull origin docker-1
else 
 git clone  https://github.com/PraveenKumarDova/addressbook.git

fi

cd /home/ec2-user/addressbook

git checkout docker-1
sudo docker build -t $1:$2 /home/ec2-user/addressbook