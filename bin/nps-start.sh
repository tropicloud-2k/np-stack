function nps_start() {
	
	if [[  $2 == "-i"  ]]; then
	
		if [[  ! -f '/var/log/php-fpm.log'  ]]; then touch /var/log/php-fpm.log; fi
		if [[  ! -f '/var/log/nginx.log'    ]]; then touch /var/log/nginx.log; fi
		
		nps_environment
		
		/usr/bin/supervisord -n -c /etc/supervisord.conf
		
	else
		
		if [[  -z $2  ]]; then process="all"; else process="$2"; fi
		
		/usr/bin/supervisorctl start $process
		
	fi
	
}