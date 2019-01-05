#!/bin/bash
#function run function
#check user
if [[ $EUID -ne 0 ]]; then
	echo "are you root ?"
	exit
fi
#check paket
ls /etc/apt/sources.list.d/ > /tmp/session.txt
if ! grep -q "ondrej-ubuntu-php-bionic.list" /tmp/session.txt;then 
	echo "ppa ondrej is not installed on your computer adding ppa ondrej ..."
	add-apt-repository ppa:ondrej/php -y
fi

#function sub 1
function ins() {
	if (whiptail --title "[ warning ] " --yesno --yes-button "Install" --no-button "exit" "$menu not installed , You want to install it ? " 10 60);then
		apt -y install $menu
	else exit
	fi
}
function check() {
	command -v $menu > /tmp/session.txt
}
function ifcoeg(){
	if ! (check);then
		ins
	fi
	echo "switch version php to $menu ..." 
	a2dismod php*
	a2enmod $menu
	echo "restarting apache2 ..."
	/etc/init.d/apache2 restart
}
while true
do
menu=$(whiptail --title "[ Menu ]" --cancel-button "exit" --menu "Choose version below : " 15 60 5 \
"php5.6" "change php version to 5.6" \
"php7.0" "change php version to 7.0" \
"php7.1" "change php version to 7.1" \
"php7.2" "change php version to 7.2" \
"php7.3" "change php version to 7.3"  3>&1 1>&2 2>&3)

quitmenu=$?

if [[ $quitmenu = 0 ]]; then
	cd /
	ifcoeg
	whiptail --title "[ Notice ]" --msgbox "Done Check your php info via browser" 15 60
else exit
fi
done
