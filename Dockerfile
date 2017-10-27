FROM debian:8
MAINTAINER brian.wojtczak@1and1.co.uk
COPY files/ /
RUN \
	export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && \
	rm /etc/apt/apt.conf.d/docker-no-languages && \
	debconf-set-selections -v /etc/debconf-preseed.txt && \
	apt-get update && \
	apt-get upgrade && \
	apt-get install --no-install-recommends apt-utils debconf-utils && \
	apt-get install --no-install-recommends locales ssmtp && \
	dpkg-reconfigure -f noninteractive tzdata && \
	chmod -R 777 /var/run /var/log /etc/ssmtp /etc/passwd /etc/group && \
	chmod -R 755 /init /hooks && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
ENV \
	LC_ALL=en_GB.UTF-8 \
	LANG=en_GB.UTF-8 \
	LANGUAGE=en_GB.UTF-8 \
	SMTP_USER="" \
	SMTP_PASS="" \
	SMTP_DOMAIN="" \
	SMTP_RELAYHOST=""
ENTRYPOINT ["/bin/bash", "/init/entrypoint"]
