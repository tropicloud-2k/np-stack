np_setup() {

	# ------------------------
	# REPOS
	# ------------------------
	
	## NGINX
	cat $nps/etc/yum/nginx.repo > /etc/yum.repos.d/nginx.repo
	
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
	               php-gd \
	               php-cli \
	               php-pear \
	               php-pdo \
	               php-mysqlnd \
	               php-pgsql \
	               php-pecl-mongo \
	               php-pecl-sqlite \
	               php-pecl-memcache \
	               php-pecl-memcached \
	               php-mbstring \
	               php-mcrypt \
	               php-xml
	               
	## Supervisor
	easy_install supervisor
	easy_install supervisor-stdout
	
	## WP-CLI
	wget -nv -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x /usr/local/bin/wp
	
	## JQ 
	wget -nv -O /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq
	chmod +x /usr/local/bin/jq
	
	# ------------------------
	# CONFIG
	# ------------------------
		
	useradd -g nginx -d $home -s /bin/false npstack
	chown root:root $home && chmod 755 $home

	cat >> /root/.bashrc <<"EOF"
for var in $(cat /etc/environment); do 
	key=$(echo $var | cut -d= -f1)
	val=$(echo $var | cut -d= -f2)
	export ${key}=${val}
done
EOF

	mkdir -p $home/html
	mkdir -p $home/ssl
		
	cat $nps/etc/supervisord.conf > /etc/supervisord.conf
	cat $nps/etc/php/php-fpm.conf > /etc/php-fpm.d/www.conf
	cat $nps/etc/nginx/nginx.conf > /etc/nginx/nginx.conf
	cat $nps/etc/nginx/app.conf   > $home/app.conf
	cat $nps/etc/html/index.html  > $home/html/index.html
	cat $nps/etc/html/info.php    > $home/html/info.php
	cat /root/.bashrc             > $home/.bashrc

	# ------------------------
	# SSL
	# ------------------------
	
	cd $home/ssl
	
	cat $nps/etc/nginx/openssl.conf > openssl.conf
	
	openssl req -nodes -sha256 -newkey rsa:2048 -keyout app.key -out app.csr -config openssl.conf -batch
	openssl rsa -in app.key -out app.key
	openssl x509 -req -days 365 -sha256 -in app.csr -signkey app.key -out app.crt
	
	rm -f openssl.conf
	
	# ------------------------
	# CHMOD
	# ------------------------

	chmod +x /usr/local/nps/np-stack
	ln -s /usr/local/nps/np-stack /usr/bin/np
	
	cd $home
	
	chown npstack:nginx -R .
	chmod -R 775 .
	
	chmod 644 $home/app.conf
}
