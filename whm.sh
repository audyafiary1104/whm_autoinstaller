#!bin/bash
IJO='\e[38;5;82m'
MAG='\e[35m'
RESET='\e[0m'
echo -e "$MAG--=[ Auto Installer Whm thanks to bukan coder ]=--$IJO"

read -p "Do you want install bot blocker? y/n " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo -e "$MAG--=[ Download bot list from Bukan Coder Archive ]=--$IJO"
yum -y install wget
cd /etc/nginx/bots.d 
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blacklist.conf.txt -O blacklist.conf
wget https://arc.bukancoder.co/Nginx-Bad-Bot-Blocker/blockips.conf.txt -O blockips.conf
    
echo
echo

echo -e "$MAG--=[ Updating Nginx Configuration ]=--$IJO"
rm -rf /etc/nginx/nginx.conf 
cat >/etc/nginx/nginx.conf<<eof
$alf
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  65;
    client_max_body_size 500M;
    #gzip  on;
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    include /etc/nginx/bots.d/*;
}
eof
echo
echo

echo -e "$MAG--=[ Blocking bots with iptables ]=--$IJO"
cd ~
wget https://arc.bukancoder.co/Bots-Iptables/block.txt -O block 
wget https://arc.bukancoder.co/Bots-Iptables/ips.txt -O ips 
chmod +x block 
./block

echo -e "$MAG--=[ Save iptables ]=--$IJO"
service iptables save

echo
echo -e "$MAG--=[Done! Bots has been blocked using Nginx Bad Bots Blocker and iptables]=--$IJO"
else


echo -e "$MAG--=[ update your os ]=--$IJO"
yum -y update
echo -e "$MAG--=[Done set Update $MAG]=--$IJO"
echo
echo -e "$MAG--=[ set your hostname ]=--$IJO"
hostname="yourhostname.com"
	read -p "hostname to add : " hostname
	if [ "$hostname" = "" ]; then
		hostname="yourdomain.com"
	fi
	if [ ! -f "hostnamectl set-hostname  $hostname" ]; then
	echo "---------------------------"
	echo "hostname : $hostname"
	echo "---------------------------" 
	else
	echo "---------------------------"
	echo "$hostname is not valid!"
	echo "---------------------------"	
	fi
echo
echo -e "$MAG--=[Done set hostname $MAG]=--$IJO"

echo -e "$MAG--=[ Installing Whm  ]=--$IJO"
curl -o latest -L https://securedownloads.cpanel.net/latest && sh latest
echo -e "$MAG--=[Done Install whm  $MAG]=--$IJO"

echo -e "$MAG--=[ Installing SSL Certificate for wh,  ]=--$IJO"
/usr/local/cpanel/scripts/install_lets_encrypt_autossl_provider
echo -e "$MAG--=[Done letsencrypt installed on your server $MAG]=--$IJO"
echo -e "$MAG--=[ Installing SSL Certificate for domain  ]=--$IJO"
echo -e "$MAG--=[ Installing exim cronie  ]=--$IJO"
yum install -y exim cronie cyrus-sasl cyrus-sasl-plain
echo -e "$MAG--=[ Done Installing exim cronie ]=--$IJO"

echo -e "$IJO--=[ FINISH SUKSES INSTALL WHM ]=--$IJO"
fi
