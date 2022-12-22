hostnamectl set-hostname "web1.cloudbinary.io"
echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install apache2 -y 
echo "`hostname -I | awk '{ print $1}'` `hostname`" > /var/www/html/index.html 
echo "I am a WebServer-1" >> /var/www/html/index.html 
#sudo systemctl restart snap.amazon-ssm-agent.amazon-ssm-agent.service

sudo snap install amazon-ssm-agent --classic
sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent
