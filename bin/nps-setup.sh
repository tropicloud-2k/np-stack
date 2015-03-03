function nps_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	## NGINX
	cat $nps/conf/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
	## EPEL
	rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
	
	## REMI
	rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
	
	# ------------------------
	# INSTALL
	# ------------------------
	
	## Dependecies
	yum install -y nano wget zip python-setuptools

	## NGINX + MariaDB Client
	yum install -y nginx mariadb
	               
	## PHP
	yum install -y --enablerepo=remi,remi-php56 \
	               php-fpm \
	               php-common \
	               php-opcache \
	               php-pecl-apcu \
	               php-cli \
	               php-pear \
	               php-pdo \
	               php-mysqlnd \
	               php-pgsql \
	               php-pecl-mongo \
	               php-pecl-sqlite \
	               php-pecl-memcache \
	               php-pecl-memcached \
	               php-gd php-mbstring \
	               php-mcrypt php-xml
	               
	## Supervisor
	easy_install supervisor
	easy_install supervisor-stdout
	
	## WP-CLI
	wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	
	## JQ 
	wget -O /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq
	chmod +x /usr/local/bin/jq
	
	# ------------------------
	# CONFIG
	# ------------------------

	mkdir -p /app/html
	mkdir -p /app/ssl
			
	cat $nps/conf/supervisor/supervisord.conf > /etc/supervisord.conf
	cat $nps/conf/nginx/default.conf > /etc/nginx/conf.d/default.conf
	cat $nps/conf/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat $nps/conf/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat $nps/conf/html/index.html > /app/html/index.html
	cat $nps/conf/html/info.php > /app/html/info.php

	# ------------------------
	# SSL CERT.
	# ------------------------
	
	cd /app/ssl
	
	cat $nps/conf/nginx/openssl.conf > openssl.conf
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -in app.csr -signkey app.key -out app.crt	
	openssl x509 -req -days 365 -sha256 -in app.csr -signkey app.key -out app.crt
	rm -f openssl.conf
	
}
