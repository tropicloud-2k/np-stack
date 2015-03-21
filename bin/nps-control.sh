# ------------------------
# NPS START
# ------------------------

function nps_start() {
	
	nps_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl start all;
		else /usr/bin/supervisorctl start $2;
		fi
		
	else
	
		if [[  ! -f "/var/log/php-fpm.log"  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f "/var/log/nginx.log"  ]];   then touch /var/log/nginx.log; fi
		
		exec /usr/bin/supervisord -n -c /etc/supervisord.conf
	
	fi
}

# ------------------------
# NPS STOP
# ------------------------

function nps_stop() {

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl stop all;
		else /usr/bin/supervisorctl stop $2;
		fi
	
	fi
}

# ------------------------
# NPS RESTART
# ------------------------

function nps_restart() {
	
	nps_environment

	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl restart all;
		else /usr/bin/supervisorctl restart $2;
		fi
		
	else exec /usr/bin/supervisord -n -c /etc/supervisord.conf;
	fi
}

# ------------------------
# NPS RELOAD
# ------------------------

function nps_reload() {

	nps_environment

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl reload;
	fi
}

# ------------------------
# NPS STATUS
# ------------------------

function nps_status() {
	
	if [[  -f /tmp/supervisord.pid  ]]; then
	
		if [[  -z $2  ]];
		then /usr/bin/supervisorctl status all;
		else /usr/bin/supervisorctl status $2;
		fi
	
	fi
}

# ------------------------
# NPS LOG
# ------------------------

function nps_log() {

	if [[  -f /tmp/supervisord.pid  ]];
	then /usr/bin/supervisorctl maintail;
	fi
}

# ------------------------
# NPS LOGIN
# ------------------------

function nps_login() {

	export TERM=xterm
	su -l npstack -s /bin/bash

}
