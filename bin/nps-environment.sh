function nps_environment() {
	
	# ------------------------
	# DATABASE URL
	# ------------------------
	
	if [[  -z $DATABASE_URL  ]]; then

		DB_HOST=$(env | grep 'DB_PORT_3306_TCP_ADDR' | cut -d= -f2)
		export DB_HOST=$DB_HOST
		DB_PORT=$(env | grep 'DB_PORT_3306_TCP_PORT' | cut -d= -f2)
		export DB_PORT=$DB_PORT
		DB_NAME=$(env | grep 'DB_ENV_MYSQL_DATABASE' | cut -d= -f2)
		export DB_NAME=$DB_NAME
		DB_USER=$(env | grep 'DB_ENV_MYSQL_USER' | cut -d= -f2)
		export DB_USER=$DB_USER
		DB_PASS=$(env | grep 'DB_ENV_MYSQL_PASSWORD' | cut -d= -f2)
		export DB_PASS=$DB_PASS
		DB_PROT=$(env | grep 'DB_PORT_3306_TCP_PROTO' | cut -d= -f2)
		export DB_PROT=$DB_PROT
		
		export DATABASE_URL=${DB_PROT}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME}

	else

		DB_HOST=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d: -f1)
		export DB_HOST=$DB_HOST
		DB_PORT=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d: -f2 | cut -d/ -f1)
		export DB_PORT=$DB_PORT
		DB_NAME=$(env | grep 'DATABASE_URL' | cut -d@ -f2 | cut -d\/ -f2)
		export DB_NAME=$DB_NAME
		DB_USER=$(env | grep 'DATABASE_URL' | cut -d: -f2 | sed 's|//||g')
		export DB_USER=$DB_USER
		DB_PASS=$(env | grep 'DATABASE_URL' | cut -d: -f3 | cut -d@ -f1)
		export DB_PASS=$DB_PASS
	
	fi

	# ------------------------
	# ENV. SETUP
	# ------------------------

	echo "" > /etc/environment
	env | grep = >> /etc/environment

	if [[  -d '/etc/env'  ]];
	then rm -f /etc/env/*
	else mkdir -p /etc/env
	fi

	for var in $(cat /etc/environment); do 
		key=$(echo $var | cut -d= -f1)
		val=$(echo $var | cut -d= -f2)
		echo -ne $val > /etc/env/${key}
	done
	
	chown npstack:nginx /etc/environment && chmod 750 /etc/environment
	chown -R npstack:nginx /etc/env && chmod -R 750 /etc/env
	
}