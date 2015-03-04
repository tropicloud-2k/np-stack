FROM centos:centos7
MAINTAINER "Tropicloud" <admin@tropicloud.net>


ADD . /usr/local/nps
RUN /usr/bin/chmod +x /usr/local/nps/np-stack && /usr/bin/ln -s /usr/local/nps/np-stack /usr/bin/nps
RUN /usr/bin/nps setup

ENTRYPOINT ["/usr/bin/nps"]
CMD ["start","0"]

EXPOSE 80 443

