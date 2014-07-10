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
echo "||     Version 2.0                           ||" 
echo "||                                           ||"
echo "||     Please feel free to improve           ||"
echo "||     this script however you desire.       ||"
echo "||                                           ||"
echo "||     junior.holowka@gmail.com              ||"
echo "||===========================================||"



#---------------------------------------------#
#         APACHE/MYSQL/PHP                    #
#---------------------------------------------#

function Installamp {	

echo -e "\033[1m===> Instalando Apache, Mysql e PHP ... \033[0m\n"

apt-get -y install \
	apache2 libapache2-mod-php5 php5 php5-cli php5-intl php5-dev \
	php5-fpm php-pear php5-imagick php5-sqlite php5-xcache \
	php5-xsl php5-memcache php5-curl php5-gd \
	php5-mcrypt php5-common php5-mysql

echo -e "\033[1m===> Instalando Mysql ... \033[0m\n"

apt-get -y install mysql-server mysql-client 

echo -e "\033[1m===> Instalando MySQL GUI Tools ... \033[0m\n"

sudo apt-get update
apt-get -y install mysql-workbench

sudo /etc/init.d/apache2 restart

echo -e "\033[1m===> Apache, Mysql e PHP instalado com sucesso! \033[0m\n"

}
## FIM APACHE/MYSQL/PHP


#---------------------------------------------#
#         ECLIPSE CLASSIC                     #
#---------------------------------------------#

function InstallEclipse {

echo -e "\033[1m===> Instalando Java JDK (Java SE Development Kit)  ... \033[0m\n"
	apt-get -y install openjdk-7-jdk
echo ""

echo -e "\033[1m===> Baixando Eclipse Luna no site oficial (htp://www.eclipse.org) ... \033[0m\n"

PROCESSADOR=`uname -p`
if test $PROCESSADOR = "i686"
	then
		wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk.tar.gz
        echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
        tar -xzf eclipse-standard-luna-R-linux-gtk.tar.gz
	else
		wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/R/eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz
        echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
        tar -xzf eclipse-standard-luna-R-linux-gtk-x86_64.tar.gz
fi		

echo "Download completo!"	
echo ""

if [ -e /usr/local/eclipse ]
	then
		echo "removendo diretório antigo do eclipse"
		sudo rm -R /usr/local/eclipse
fi	

echo -e "\033[1m===> Copiando arquivo para /usr/local ... \033[0m\n"
sudo cp -R eclipse /usr/local
echo ""	

echo -e "\033[1m===> Copiando ícone do Eclipse para o diretório de ícones do sistema ... \033[0m\n"
sudo cp /usr/local/eclipse/icon.xpm /usr/share/pixmaps/eclipse.png
echo ""

echo -e "\033[1m===> Criando atalho no menu de aplicativos ... \033[0m\n"
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

echo ""

echo -e "\033[1m===> Criando grupo DEVELOPMENT e inserindo usuário no grupo ... \033[0m\n"
sudo addgroup development
sudo usermod -a -G development $(whoami)
echo ""

echo -e "\033[1m===> Configurando arquivos do Eclipse para pertencerem ao grupo DEVELOPMENT ... \033[0m\n"
sudo chgrp development -R /usr/local/eclipse/
sudo chmod g+w -R /usr/local/eclipse/
echo ""

sudo rm -R eclipse

echo -e "\033[1m===> Eclipse Classic instalado com sucesso! \033[0m\n"
echo ""
}

## END ECLIPSE 


#----------------------------------#
#          MENU PRINCIPAL          #
#----------------------------------#

function Menu {
echo ""
echo "-----------------------------------------------------------------"
echo "What would you like to do? (enter the desired option number) "; echo "";
INPUT=0
while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ]
do
echo "1. Install Apache2, Mysql 5 e PHP5"
echo "2. Install Eclipse Luna Classic"
echo "3. Exit"


read INPUT
if [ $INPUT -eq 1 ] 
then
	Installamp
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
	echo "opção invalida"
	Menu
fi
fi
fi

done
}


#----------------------------------#
#      CHAMA O MENU PRINCIPAL      #
#----------------------------------#

Menu

# FIM 








