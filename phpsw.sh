whiptail --title "welcome to php switcher" --msgbox "Welcome to PHPSW \n\
easy manage for Switch php version and install it \n\n--for apache2 user \nCreate by Hecate " 15 60
if [[ $EUID -ne 0 ]]; then
	whiptail --title "[ warning ! ]" --msgbox "Please run it in root mode or use \"sudo\" for ubuntu user" --ok-button "exit" 10 60
	exit
else clear
fi
if (whiptail --title "[ ppa ]" --yesno --yes-button "Install" "would you want to add repository ppa:ondrej/php for install another php version ? " 10 60);then
	add-apt-repository ppa:ondrej/php
fi
while true
do
menu=$(whiptail --title "[ Menu ]" --cancel-button "exit" --menu "Choose version below : " 15 60 5 \
"php5.6" "" \
"php7.0" "" \
"php7.1" "" \
"php7.2" "" \
"php7.3" ""  3>&1 1>&2 2>&3)

quitmenu=$?

if [[ $quitmenu = 0 ]]; then
	echo ""
else exit
fi

if ! [ -x "$(command -v $menu)" ];then
	if (whiptail --title "[ warning ] " --yesno --yes-button "Install" "$menu not installed , You want to install it ? " 10 60);then
		apt -y install $menu
	else exit 
	fi
fi
pwd > /tmp/place
		place=`cat /tmp/place`
		cd
		a2dismod php*
		a2enmod $menu
		cd $place
		clear
		/etc/init.d/apache2 restart
		whiptail --title "[ change ]" --msgbox "php already changed to $menu " 10 60
done