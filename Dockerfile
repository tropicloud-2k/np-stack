FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>


ADD . /usr/local/nps
RUN /usr/bin/chmod +x /usr/local/nps/np-stack && /usr/local/nps/np-stack setup

EXPOSE 80 443
ENTRYPOINT ["nps"]
CMD ["start","0"]
