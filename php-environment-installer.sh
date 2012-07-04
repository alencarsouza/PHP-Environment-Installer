#!/bin/bash


# PHP Environment Installer:

# feel free to change, update, improve, and release this script

# suggestions of feedback? reach me at junior.holowka@gmail.com

# latest update 14/Jun/2012

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
	sudo apt-get update
	$install mysql-workbench
	
	sudo /etc/init.d/apache2 restart
	
	echo -e "\033[1m===> Apache, Mysql e PHP instalado com sucesso! \033[0m\n"
}

## FIM APACHE/MYSQL/PHP

#---------------------------------------------#
#       CONTINUOUS INTEGRATION IN PHP         #
#---------------------------------------------#
	
function InstallPunit {

	## PHP Unit
	# usage: 
	# phpunit . 
	# phpunit --coverage-html ../folder .

	
	echo -e "\033[1m===> Instalando PHPUnit ... \033[0m\n"
	$install php5-curl php-pear php5-dev

	echo -e "\033[1m===> Atualizando a versão do PEAR ... \033[0m\n"
	sudo pear upgrade pear

	echo -e "\033[1m===> Instalando dependências do PHPUnit ... \033[0m\n"
	sudo pear channel-discover pear.phpunit.de
	sudo pear channel-discover components.ez.no
	sudo pear channel-discover pear.symfony-project.com
	sudo pear install phpunit/PHPUnit
	
	echo -e "\033[1m===> PHPUnit instalado com sucesso! \033[0m\n"
	echo ""

	## PHP CodeSniffer
	# usage:
	# phpcs file.php
	# phpcs --report=summary folder/

	sudo pear install PHP_CodeSniffer

	## PHP Depend
	# usage: 
	# pdepend --jdepend-xml=../jdepend.xml --jdepend-chart=../dependencies.svg --overview-pyramid=../overview-pyramid.svg .

	sudo pear channel-discover pear.pdepend.org
	sudo pear install pdepend/PHP_Depend-beta

	## PHP Mess Detector
	# usage:
	# phpmd . html codesize,unusedcode,naming,design --reportfile ../messdetector.html --exclude Tests/

	sudo pear channel-discover pear.phpmd.org
	sudo pear channel-discover pear.pdepend.org
	sudo pear install --alldeps phpmd/PHP_PMD

	## PHP Copy/Paste Detector
	# usage:
	# phpcpd .

	sudo pear channel-discover pear.phpunit.de
	sudo pear channel-discover components.ez.no
	sudo pear install phpunit/phpcpd

	## PHP Dead Code Detector
	# usage:
	# phpdcd --exclude Tests/ .

	sudo pear channel-discover pear.phpunit.de
	sudo pear channel-discover components.ez.no
	sudo pear install phpunit/phpdcd-beta
}

## FIM CONTINUOUS

#---------------------------------------------#
#         XDEBUG                              #
#---------------------------------------------#

function InstallXdebug {
	
	echo -e "\033[1m===> Instalando Xdebug ... \033[0m\n"
	$install php5-dev php-pear
	sudo pecl install xdebug

	echo -e "\033[1m===> Criando diretórios de log ... \033[0m\n"
	sudo mkdir -pv /tmp/xdebug/profile
	sudo mkdir -pv /tmp/xdebug/trace

	echo -e "\033[1m===> Criando o arquivo xdebug.ini ... \033[0m\n"
	sudo touch /etc/php5/conf.d/xdebug.ini

	sudo bash -c 'cat > /etc/php5/conf.d/xdebug.ini'<<-EOF
	[xdebug]
	zend_extension=/usr/lib/php5/20090626/xdebug.so

	; Remote
	xdebug.remote_enable  = On
	xdebug.remote_host    = localhost ; host or IP name of the machine running VIM
	xdebug.remote_port    = 9000      ; port on which debugger.py is listening
	xdebug.remote_mode    = "req"     ; connect on request start
	xdebug.remote_handler = "DBGp"
	xdebug.var_display_max_depth = 15 
	xdebug.var_display_max_data = 4096
	xdebug.max_nesting_level = 200

	; Profiling
	xdebug.profiler_aggregate = 1
	xdebug.profiler_output_name = cachegrind.out.%H%R
	xdebug.profiler_enable = 1
	xdebug.profiler_output_dir = /tmp/xdebug/profile
	xdebug.auto_trace = 0
	xdebug.trace_output_dir = /tmp/xdebug/trace
	EOF


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

	echo -e "\033[1m===> Configurando o arquivo apc.ini ... \033[0m\n"
	sudo touch /etc/php5/conf.d/apc.ini

	sudo bash -c 'cat > /etc/php5/conf.d/apc.ini'<<-EOF
	[apc]
	extension=apc.so
	apc.enabled=1
	apc.shm_segments=1
	apc.shm_size=512M
	apc.optimization=0
	apc.ttl=7200
	apc.user_ttl=7200
	apc.num_files_hint=1000
	apc.mmap_file_mask=/tmp/apc.XXXXXX	
	EOF
	
	echo -e "\033[1m===> APC instalado com sucesso! \033[0m\n"
	echo ""
}

## END APC



#---------------------------------------------#
#         ECLIPSE CLASSIC                     #
#---------------------------------------------#

function InstallEclipse {

	echo -e "\033[1m===> Instalando Java JDK (Java SE Development Kit)  ... \033[0m\n"
	$install openjdk-6-jdk
	echo ""

	echo -e "\033[1m===> Baixando Eclipse Juno no site oficial (htp://www.eclipse.org) ... \033[0m\n"
	
	PROCESSADOR=`uname -p`
	if test $PROCESSADOR = "i686"
		then
            wget ftp://ftp.pucpr.br/eclipse/eclipse/downloads/drops4/R-4.2-201206081400/eclipse-SDK-4.2-linux-gtk.tar.gz
            echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
            tar -xzf eclipse-SDK-4.2-linux-gtk.tar.gz
		else
            wget ftp://ftp.pucpr.br/eclipse/eclipse/downloads/drops4/R-4.2-201206081400/eclipse-SDK-4.2-linux-gtk-x86_64.tar.gz
            echo -e "\033[1m===> Descompactando arquivo ... \033[0m\n"
            tar -xzf eclipse-SDK-4.2-linux-gtk-x86_64.tar.gz
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

## END NETBEANS


#---------------------------------------------#
#         BROWSER                             #
#---------------------------------------------#

function InstallBrowser {
	
	echo -e "\033[1m===> Criando repósitório ... \033[0m\n"
	sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
	
	echo -e "\033[1m===> Atualizando Repositórios ... \033[0m\n"
	sudo apt-get update

	echo -e "\033[1m===> Instalando versão estável do Google Chrome ... \033[0m\n"
	$install google-chrome-stable
	
	echo -e "\033[1m===> Google Chrome instalado com sucesso! \033[0m\n"
	echo ""
}

## END BROWSER


#----------------------------------#
#          MENU PRINCIPAL          #
#----------------------------------#

function Menu {
echo ""
echo "-----------------------------------------------------------------"
echo "What would you like to do? (enter the desired option number) "; echo "";
INPUT=0
while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ] && [ $INPUT != 4 ] && [ $INPUT != 5 ] && [ $INPUT != 6 ] && [ $INPUT != 7 ]
do
echo "1. Install Apache2, Mysql 5 e PHP5"
echo "2. Install Continuous Integration In PHP"
echo "3. Install Xdebug"
echo "4. Install APC"
echo "5. Install Eclipse Juno Classic"
echo "6. Install NetBeans 7.1"
echo "7. Install Google Chrome"
echo "8. Exit"


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








