
## -*- docker-image-name: "scaleway/docker:latest" -*-
FROM scaleway/ubuntu:vivid
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q   \
	apparmor			\
	arping				\
	aufs-tools			\
	btrfs-tools			\
	bridge-utils                    \
	cgroup-lite			\
	git				\
	ifupdown			\
	kmod				\
	lxc				\
	python-setuptools               \
	vlan				\
 && apt-get clean


# Install Docker dependencies
RUN apt-get install $(apt-cache depends docker.io | grep Depends | sed "s/.*ends:\ //" | tr '\n' ' ')


# Install Docker
ENV DOCKER_VERSION 1.8.2
ENV DOCKER_FIX -1
# docker-hypriot_XXX_armhf.deb built using https://github.com/hypriot/rpi-docker-builder
RUN wget -q http://downloads.hypriot.com/docker-hypriot_${DOCKER_VERSION}${DOCKER_FIX}_armhf.deb -O /tmp/docker.deb \
 && dpkg -i /tmp/docker.deb \
 && rm -f /tmp/docker.deb \
 && systemctl enable docker
 
 
# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework && \
    chmod +x /usr/local/bin/pipework


# Install Gosu
ENV GOSU_VERSION 1.4
RUN wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf && \
    chmod +x /usr/local/bin/gosu


# Install Docker Compose
RUN easy_install -U pip \
 && pip install docker-compose \
 && ln -s /usr/local/bin/docker-compose /usr/local/bin/fig


# Install Docker Machine
ENV DOCKER_MACHINE_VERSION 0.4.1
RUN wget -qO /usr/local/bin/docker-machine https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine_linux-arm \
 && chmod +x /usr/local/bin/docker-machine


# Patch rootfs
ADD ./patches/etc/ /etc/
ADD ./patches/usr/bin/ /usr/bin/
ADD ./patches/usr/local/ /usr/local/
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
