#!/bin/bash -e
#
# setup-phpenv.sh - Setup PHP Environment Installer with Eclipse IDE
#
# Copyright (c) 2013 Junior Holowka <junior.holowka@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# HOWTO: sudo ./setup-phpenv.sh


echo ""
echo "||===========================================||"
echo "||     PHP Environment Installer             ||"
echo "||     Version 2.1                           ||" 
echo "||                                           ||"
echo "||     Please feel free to improve           ||"
echo "||     this script however you desire.       ||"
echo "||                                           ||"
echo "||     junior.holowka@gmail.com              ||"
echo "||===========================================||"
echo ""


#---------------------------------------------#
#         NGINX/MYSQL/PHP                     #
#---------------------------------------------#

function Installnmp {	

echo -e "\033[1m===> Installing Nginx and PHP 5.6 ... \033[0m\n"

apt-get -y install software-properties-common
add-apt-repository -y ppa:ondrej/php5-5.6

apt-get -y update && apt-get -y upgrade

apt-get -y install \
	nginx-full php5 php5-cli php5-intl php5-dev php5-pgsql \
	php5-fpm php-pear php5-sqlite php5-xcache php5-xdebug \
	php5-xsl php5-memcache php5-curl php5-gd \
	php5-mcrypt php5-common php5-mysql \
	php5-imagick imagemagick

echo -e "\033[1m===> Installing Mysql 5.6 ... \033[0m\n"

apt-get install mysql-client-5.6 mysql-client-core-5.6 mysql-server-5.6

echo -e "\033[1m===> Success! \033[0m\n"

}
## END NGINX/MYSQL/PHP


#---------------------------------------------#
#         ECLIPSE CLASSIC                     #
#---------------------------------------------#

function InstallEclipse {

echo -e "\033[1m===> Installing Java ... \033[0m\n"
	add-apt-repository -y ppa:webupd8team/java
	apt-get -y update
	apt-get install --yes --force-yes \
		oracle-java8-installer oracle-java8-set-default
echo ""

echo -e "\033[1m===> Downloading Eclipse Luna (htp://www.eclipse.org) ... \033[0m\n"

PROCESSADOR=`uname -p`
if test $PROCESSADOR = "i686"
	then
		wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk.tar.gz
        echo -e "\033[1m===> Unpacking file ... \033[0m\n"
        tar -xzf eclipse-standard-luna-R-linux-gtk.tar.gz
	else
		wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz
        echo -e "\033[1m===> Unpacking file ... \033[0m\n"
        tar -xzf eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz
fi		
echo ""

if [ -e /usr/local/eclipse ]
	then
		echo "Removing old eclipse path..."
		sudo rm -R /usr/local/eclipse
fi	

echo -e "\033[1m===> Moving unpacked files to /usr/local ... \033[0m\n"
sudo cp -R eclipse /usr/local
echo ""

sudo cp /usr/local/eclipse/icon.xpm /usr/share/pixmaps/eclipse.png

sudo touch /usr/share/applications/eclipse.desktop

sudo bash -c 'cat > /usr/share/applications/eclipse.desktop'<<-EOF
[Desktop Entry]
Comment=Eclipse SDK
Name=Eclipse SDK
Exec=/usr/local/eclipse/eclipse
MultipleArgs=true
Terminal=false
Type=Application
Categories=Application;Development;
Icon=eclipse.png
EOF

sudo addgroup development
sudo usermod -a -G development $(whoami)

sudo chgrp development -R /usr/local/eclipse/
sudo chmod g+w -R /usr/local/eclipse/

sudo rm -R eclipse

echo -e "\033[1m===> Success! \033[0m\n"
echo ""
}
## END ECLIPSE 


#----------------------------------#
#            MENU                  #
#----------------------------------#

function Menu {
echo ""
echo "-----------------------------------------------------------------"
echo "What would you like to do? (enter the desired option number) "; echo "";
INPUT=0
while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ]
do
echo "1. Install Nginx, Mysql 5.6 and PHP 5.6"
echo "2. Install Eclipse Luna Classic"
echo "3. Exit"


read INPUT
if [ $INPUT -eq 1 ] 
then
	Installnmp
	Menu
	return
else 
if [ $INPUT -eq 2 ]
then
	InstallEclipse
	Menu
	return
else
if [ $INPUT -eq 3 ]
then
	return
else
	echo "Invalid!"
	Menu
fi
fi
fi

done
}


#----------------------------------#
#        START MENU                #
#----------------------------------#

Menu

# END 








