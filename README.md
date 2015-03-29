<img src="http://assets.tropicloud.net/wpstack/logo-npstack-light.png" width="240" border="0" style="display: block; max-width:100%;">

NGINX + PHP-FPM web stack for Docker.  
For database connection you may read:

* [Container Linking](https://docs.docker.com/userguide/dockerlinks/#docker-container-linking)
* [MariaDB](https://registry.hub.docker.com/_/mariadb/)

#### Pull from Docker Hub
    docker pull tropicloud/np-stack
    

or

#### Build from GitHub
    git clone https://github.com/tropicloud/np-stack.git
    docker build -t tropicloud/np-stack np-stack
    

then

#### Run the Docker image
    docker run -p 80:80 -p 443:443 -d tropicloud/np-stack 
    

Navigate to `http://<docker-host-ip>/` to check the installation.

#### Example Configuration
Make sure to build from GitHub or to include your own config files.

    docker run -p 80:80 -p 443:443 \
    -v /app/html \
    -v $(pwd)/conf/nginx/default.conf:/etc/nginx/default.conf \
    -v $(pwd)/conf/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v $(pwd)/conf/php/php-fpm.conf:/etc/php-fpm.d/www.conf \
    -d tropicloud/np-stack
    
