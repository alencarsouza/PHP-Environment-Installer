#!/bin/bash


# PHP Environment Installer:

# feel free to change, update, improve, and release this script

# suggestions of feedback? reach me at junior.holowka@gmail.com

# latest update 08/January/2012

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

install="sudo apt-get install --yes --force-yes"


#---------------------------------------------#
#         APACHE/MYSQL/PHP                    #
#---------------------------------------------#

function Installamp {
	
	echo -e "\033[1m===> Instalando Apache, Mysql e PHP ... \033[0m\n"
	
	$install apache2 libapache2-mod-php5 php5 php5-cli php5-intl
	$install php5-sqlite php5-suhosin php5-xcache php5-xsl php5-memcache
	$install php5-curl php5-gd php5-mcrypt php5-json php5-mysql 
	$install mysql-server mysql-client 

	echo -e "\033[1m===> Instalando MySQL GUI Tools ... \033[0m\n"

	$install mysql-admin mysql-query-browser
	sudo apt-add-repository ppa:junior-holowka/misc
	sudo apt-get update
	$install mysql-workbench-gpl
	
	sudo /etc/init.d/apache2 restart
	
	echo -e "\033[1m===> Apache, Mysql e PHP instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM APACHE/MYSQL/PHP


#---------------------------------------------#
#         PHPUnit                             #
#---------------------------------------------#

function InstallPunit {
	
	echo -e "\033[1m===> Instalando PHPUnit ... \033[0m\n"
	$install phpunit

	echo -e "\033[1m===> Atualizando a versão do PEAR ... \033[0m\n"
	sudo pear upgrade pear

	echo -e "\033[1m===> Instalando dependências do PHPUnit ... \033[0m\n"
	sudo pear channel-discover pear.phpunit.de
	sudo pear channel-discover components.ez.no
	sudo pear channel-discover pear.symfony-project.com
	sudo pear install --alldeps phpunit/PHPUnit
	
	echo -e "\033[1m===> PHPUnit instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM PHPUnit


#---------------------------------------------#
#         XDEBUG                              #
#---------------------------------------------#

function InstallXdebug {
	
	echo -e "\033[1m===> Instalando Xdebug ... \033[0m\n"
	$install php5-dev php-pear
	sudo pecl install xdebug

	echo -e "\033[1m===> Criando o arquivo xdebug.ini ... \033[0m\n"
	sudo touch /etc/php5/conf.d/xdebug.ini

	sudo sh -c 'echo "" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "[xdebug]" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "zend_extension=/usr/lib/php5/20090626+lfs/xdebug.so" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "" >> /etc/php5/conf.d/xdebug.ini'	

	sudo sh -c 'echo "xdebug.remote_port = 9100" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "xdebug.remote_handler= dbgp" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "xdebug.remote_host= localhost" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "xdebug.remote_enable = On" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "" >> /etc/php5/conf.d/xdebug.ini'	

	sudo sh -c 'echo "xdebug.profiler_enable = On" >> /etc/php5/conf.d/xdebug.ini'
	sudo sh -c 'echo "xdebug.profiler_output_name = cachegrind.out" >> /etc/php5/conf.d/xdebug.ini'

	echo -e "\033[1m===> Reiniciando o Apache \033[0m\n"
	sudo /etc/init.d/apache2 restart

	echo -e "\033[1m===> Xdebug instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM XDEBUG


#---------------------------------------------#
#         APC                                 #
#---------------------------------------------#

function Installapc {
	
	echo -e "\033[1m===> Instalando APC ... \033[0m\n"
	$install php5-dev php-pear
	sudo pecl install apc

	echo -e "\033[1m===> Configurando o arquivo php.ini ... \033[0m\n"
	sudo sh -c 'echo "" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "extension=apc.so" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "[apc]" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.enabled = 1" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.shm_segments = 1" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.shm_size = 30" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.optimization = 0" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.ttl = 7200" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.user_ttl = 7200" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.num_files_hint = 1000" >> /etc/php5/apache2/php.ini'
	sudo sh -c 'echo "apc.mmap_file_mask = /tmp/apc.XXXXXX" >> /etc/php5/apache2/php.ini'
	
	echo -e "\033[1m===> APC instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM APC



#---------------------------------------------#
#         ECLIPSE CLASSIC                     #
#---------------------------------------------#

function InstallEclipse {

	echo -e "\033[1m===> Instalando Java JDK (Java SE Development Kit)  ... \033[0m\n"
	$install openjdk-6-jdk
	echo ""

	echo -e "\033[1m===> Baixando Eclipse no site oficial (htp://www.eclipse.org) ... \033[0m\n"
	
	PROCESSADOR=`uname -p`
	if test $PROCESSADOR = "i686"
		then
			wget http://eclipse.c3sl.ufpr.br/eclipse/downloads/drops/R-3.7.2-201202080800/eclipse-SDK-3.7.2-linux-gtk.tar.gz
			echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
			tar -xzf eclipse-SDK-3.7.2-linux-gtk.tar.gz	
		else
			wget http://eclipse.c3sl.ufpr.br/eclipse/downloads/drops/R-3.7.1-201109091335/eclipse-SDK-3.7.1-linux-gtk-x86_64.tar.gz
			echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
 			tar -xzf eclipse-SDK-3.7.1-linux-gtk-x86_64.tar.gz
	fi		
	
	echo "Download completo!"
	echo ""

	
	echo ""

	echo -e "\033[1m===> Copiando arquivo para /usr/local ... \033[0m\n"
	sudo cp -R eclipse /usr/local
	echo ""

	echo -e "\033[1m===> Copiando ícone do Eclipse para o diretório de ícones do sistema ... \033[0m\n"
	sudo cp /usr/local/eclipse/icon.xpm /usr/share/pixmaps/
	echo ""

	echo -e "\033[1m===> Criando atalho no menu de aplicativos ... \033[0m\n"
	sudo touch /usr/share/applications/eclipse.desktop
	sudo sh -c 'echo "[Desktop Entry]" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Comment=Eclipse SDK" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Name=Eclipse SDK" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Exec=/usr/local/eclipse/eclipse" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "MultipleArgs=true" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Terminal=false" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Type=Application" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Categories=Application;Development;" >> /usr/share/applications/eclipse.desktop'
	sudo sh -c 'echo "Icon=icon.xpm" >> /usr/share/applications/eclipse.desktop'
	echo ""

	echo -e "\033[1m===> Criando grupo DEVELOPMENT e inserindo usuário no grupo ... \033[0m\n"
	sudo addgroup development
	sudo usermod -a -G development $(whoami)
	echo ""

	echo -e "\033[1m===> Configurando arquivos do Eclipse para pertencerem ao grupo DEVELOPMENT ... \033[0m\n"
	sudo chgrp development -R /usr/local/eclipse/
	sudo chmod g+w -R /usr/local/eclipse/
	echo ""

	sudo rm eclipse-SDK-3.7.1-linux-gtk-x86_64.tar.gz
	sudo rm -R eclipse

	echo -e "\033[1m===> Eclipse Classic instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM ECLIPSE CLASSIC 

#---------------------------------------------#
#         NETBEANS 7.1                        #
#---------------------------------------------#

function InstallNbeans {

	echo -e "\033[1m===> Instalando Java JDK (Java SE Development Kit)  ... \033[0m\n"
	$install sun-java6-jdk
	echo ""

	echo -e "\033[1m===> Verificando se o Java foi instalado  ... \033[0m\n"
	java -version
	echo ""
	
	echo -e "\033[1m===> Baixando o NetBeans 7.1 no site oficial (http://netbeans.org/) ... \033[0m\n"
	wget http://download.netbeans.org/netbeans/7.1/final/bundles/netbeans-7.1-ml-linux.sh
	echo "Download completo!"
	echo ""

	echo -e "\033[1m===> Instalando o NetBeans 7.1 ... \033[0m\n"
	sudo chmod +x netbeans-7.1-ml-linux.sh
	sudo ./netbeans-7.1-ml-linux.sh
	echo ""

	echo -e "\033[1m===> NetBeans 7.1 instalado com sucesso! \033[0m\n"
	echo ""

	
}

## FIM NETBEANS


#---------------------------------------------#
#         BROWSER                             #
#---------------------------------------------#

function InstallBrowser {
	
	echo -e "\033[1m===> Criando repósitório ... \033[0m\n"
	wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	
	echo -e "\033[1m===> Atualizando Repositórios ... \033[0m\n"
	sudo apt-get update

	echo -e "\033[1m===> Instalando versão estável do Google Chrome ... \033[0m\n"
	$install google-chrome-stable
	
	echo -e "\033[1m===> Google Chrome instalado com sucesso! \033[0m\n"
	echo ""
}

## FIM BROWSER


#----------------------------------#
#          MENU PRINCIPAL          #
#----------------------------------#

function Menu {
echo ""
echo "-----------------------------------------------------------------"
echo "O que você gostaria de fazer? (digite o numero da opção desejada) "; echo "";
INPUT=0
while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ] && [ $INPUT != 4 ] && [ $INPUT != 5 ] && [ $INPUT != 6 ] && [ $INPUT != 7 ]
do
echo "1. Instalar Apache2 / Mysql 5 e PHP5"
echo "2. Instalar PHPUnit"
echo "3. Instalar Xdebug"
echo "4. Instalar APC"
echo "5. Instalar Eclipse Classic"
echo "6. Instalar NetBeans 7.1"
echo "7. Instalar Google Chrome"
echo "8. Sair"


read INPUT
if [ $INPUT -eq 1 ] 
then
	Installamp
	Menu
	return
else 
if [ $INPUT -eq 2 ] 
then
	InstallPunit
	Menu
	return
else
if [ $INPUT -eq 3 ]
then
	InstallXdebug
	Menu
	return
else
if [ $INPUT -eq 4 ]
then
	Installapc
	Menu
	return
else
if [ $INPUT -eq 5 ]
then
	InstallEclipse
	Menu
	return
else
if [ $INPUT -eq 6 ]
then
	InstallNbeans
	Menu
	return
else
if [ $INPUT -eq 7 ]
then
	InstallBrowser
	Menu
	return
else
if [ $INPUT -eq 8 ]
then
	return
else

	echo "opção invalida"
	Menu
fi
fi
fi
fi
fi
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








