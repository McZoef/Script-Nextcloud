 #!/bin/bash

clear
echo "Hallo Gebruiker, Met dit script ga je Nextcloud, Fail to ban en een firewall installeren."
read -p "Wilt u hiermee verder gaan? Y/N?" yn
        case $yn in
	    [Yy]* )
echo "Oke gaan we aan de slag"
echo "___________________________________________"
	

echo "Vul je gebruikersnaam in"
read user

sudo apt update
sudo apt install apache2
sudo apt install php
sudo apt install mariadb-server
sudo mysql_secure_installation

sudo apt install apache2
sudo systemctl enable apache2.service

echo "MariaDB opent zometeen. Maak de benodigde databases aan. Flush ook de priveleges en geef de rechten aan Nextcloud"
echo "Nu gaan we Nextcloud zelf installeren"
sudo wget  /home/"$user"/nextcloud.zip https://download.nextcloud.com/server/releases/nextcloud-21.0.2.zip
cd /home/"$user"/
unzip -o nextcloud-21.0.2.zip -d /var/www/

echo "pas nu de startup voor Apache aan zodat deze opstart naar Nextcloud"
sleep 7s
sudo nano /etc/apache2/sites-available/nextcloud.conf

sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime setenvif ssl
sudo chmod 775 -R /var/www/nextcloud/
sudo chown www-data:www-data /var/www/nextcloud/ -R
sudo systemctl restart apache2
echo "we zijn klaar met de installatie, Je kunt nu aan de slag met Nextcloud. Nu gaan we beginnen met Fail 2 Ban."
read -p "Wilt u hiermee verder gaan? Y/N?" yn
        case $yn in
	    [Yy]* )
echo "Oke gaan we aan de slag"
echo "___________________________________________"
clear
sudo apt install fail2ban
sudo systemctl status fail2ban
sudo cp /etc/fail2ban/jail.{conf,local}
echo "Voeg nu de ignore IP 127.0.0.1 toe. (dmv het weghalen van het # icoon voor IgnoreIP) Mocht je extra configuraties toe willen voegen is nu het moment."
echo "Je kunt bijvoorbeeld nu IP's bannen of een Email notification toevoegen"
sleep 7s
sudo nano /etc/fail2ban/jail.local

echo "we zijn klaar met de installatie van Fail 2 Ban, Nu kunnen we verder met de Firewall en het SSL certificaat"
read -p "Wilt u hiermee verder gaan? Y/N?" yn
        case $yn in
	    [Yy]* )
echo "Oke gaan we aan de slag"
echo "___________________________________________"
clear

iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -L -n 

echo "Nu gaan we Certbot installeren voor het krijgen van SSL certificate. rond de configuratie af."

sudo snap install --classic certbot 
sudo certbot --apache 
sudo certbot --nginx 

sudo certbot renew 

 
echo "wil je het script herladen?"

read -p "Antwoord in Y/N: " opnieuwladen
echo $opnieuwladen
while $opnieuwladen = ["Y"]
clear
sleep 1s
 
do 
clear
sleep 1s
echo "Dan beginnen we opnieuw!"
sleep 1s
cd /home/$user/Desktop/
sleep 1s
sudo ./Script2.sh
	
esac