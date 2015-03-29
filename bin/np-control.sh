# ------------------------
# NP START
# ------------------------

np_start() {
	
	np_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi
		
	else
	
		if [[  ! -f "/var/log/php-fpm.log"  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f "/var/log/nginx.log"  ]]; then touch /var/log/nginx.log; fi
		if [[  ! -f "/usr/sbin/crond"  ]]; then touch /usr/sbin/crond; fi
		
		exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	
	fi
}

# ------------------------
# NP STOP
# ------------------------

np_stop() {

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl stop all;
		else /usr/bin/supervisorctl stop $2;
		fi
	
	fi
}

# ------------------------
# NP RESTART
# ------------------------

np_restart() {
	
	np_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl restart all;
		else /usr/bin/supervisorctl restart $2;
		fi
		
	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf;
	fi
}

# ------------------------
# NP RELOAD
# ------------------------

np_reload() {

	np_environment

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl reload;
	fi
}

# ------------------------
# NP STATUS
# ------------------------

np_status() {
	
	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl status all;
		else /usr/bin/supervisorctl status $2;
		fi
	
	fi
}

# ------------------------
# NP LOG
# ------------------------

np_log() {

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl maintail;
	fi
}

# ------------------------
# NP LOGIN
# ------------------------

np_login() {

	export TERM=xterm
	su -l npstack -s /bin/bash

}
