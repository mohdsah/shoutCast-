# shoutCast-

 Streamers Panel 3.x Install

F�r Neuinstall die blank_database.php umbenennen in database.php!!

Recht 777 auf folgende dateien und Ordner geben wie in der install verlangt wird

Nach der Install des Panels die database.php auf das Recht 444 setzen und folgende Dateien l�schen install.php & install.requirements.php

F�r Update von sap3.4.1 zu sap3.4.2 nur die ganzen Dateien und Ordner �berschreiben, dann die install.php & install.requirements.php l�schen 
und die Rechte nochmal kontrollieren!!

    Bevor es losgehen kann, m�ssen noch einige Dinge installiert werden.


    Vorbereitungen f�r Debian & Ubuntu:

    Falls bei Euch noch kein aptitude und/oder sudo installiert sein sollte, installiert es wie folgt.
    Code:

    apt-get update && apt-get install aptitude

    Wenn Ihr ein 64bit-System einsetzt m�ss auch noch eine 32bit Libary installiert werden.
    Code:

    aptitude install ia32-libs


1.Installation der ssh2 PHP-Extension:

    aptitude update && aptitude install sudo php5-dev php5-cli php-pear build-essential 
    
    aptitude install openssl-dev zlib1g-dev libssh2-1-dev libssh2-php wget
    
    pecl install -f ssh2
    
    echo 'extension=ssh2.so' > /etc/php5/conf.d/ssh2.ini


2.Libssh2 Installation:

    cd /usr/src

    wget http://www.libssh2.org/download/libssh2-0.14.tar.gz

    tar -zxvf libssh2-0.14.tar.gz

    cd libssh2-0.14/

    ./configure && make all install


    /etc/init.d/apache2 restart


    That's it!

    Ihr seid fertig! 

F�r andere Linux-Systeme bitte mal im Forum nach lesen http://board.streamerspanel.com/threads/630-Streamers-Panel-3-x-Install

Bei Scriptfehlern oder nicht richtige Ausf�hrung bei der erstellung der Playliste die beiliegende "php.ini" austauschen (/ect/php5/apache2/ bzw. /etc/php5/cgi/) wenn das web eine 
eigene php.ini hat dann dort austauschen und danach den apache2 neustarten. Vorher bitte die orginale "php.ini" umbennen oder sichern!!!


Have Fun.


MFG Shippo21
