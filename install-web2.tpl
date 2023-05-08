#!/bin/bash

hostnamectl set-hostname "web2.uday.io"
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install git curl wget unzip tree -y 
sudo apt-get install software-properties-common -y 
apt install awscli -y 
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent
echo "Welcome to AWS Devops WebPage2" | sudo tee /var/www/html/index.html

