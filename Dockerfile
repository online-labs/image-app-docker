## -*- docker-image-name: "scaleway/docker" -*-
FROM scaleway/ubuntu:amd64-xenial
# following 'FROM' lines are used dynamically thanks do the image-builder
# which dynamically update the Dockerfile if needed.
#FROM scaleway/ubuntu:armhf-xenial     # arch=armv7l
#FROM scaleway/ubuntu:arm64-xenial     # arch=arm64
#FROM scaleway/ubuntu:i386-xenial      # arch=i386
#FROM scaleway/ubuntu:mips-xenial      # arch=mips


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN sed -i '/mirror.scaleway/s/^/#/' /etc/apt/sources.list \
 && apt-get -q update                   \
 && echo "Y" | apt-get --force-yes -y -qq upgrade  \
 && apt-get --force-yes install -y -q   \
      apparmor                          \
      arping                            \
      aufs-tools                        \
      btrfs-tools                       \
      bridge-utils                      \
      cgroup-lite                       \
      git                               \
      ifupdown                          \
      kmod                              \
      lxc                               \
      python-setuptools                 \
      vlan                              \
 && apt-get clean


# Install Docker
RUN apt-get install -y docker.io && docker --version


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework  \
 && chmod +x /usr/local/bin/pipework


# Install Gosu
RUN apt-get install -y gosu


# Install Docker Compose
RUN apt-get install -y docker-compose && docker-compose --version


# Install Docker Machine
ENV DOCKER_MACHINE_VERSION=0.11.0
RUN case "${ARCH}" in                                                                                                                                               \
    x86_64|amd64|i386)                                                                                                                                              \
        arch_docker=x86_64;                                                                                                                                         \
        ;;                                                                                                                                                          \
    aarch64|arm64)                                                                                                                                                  \
        arch_docker=aarch64;                                                                                                                                        \
        ;;                                                                                                                                                          \
    armhf|armv7l|arm)                                                                                                                                               \
        arch_docker=armhf;                                                                                                                                          \
        ;;                                                                                                                                                          \
    *)                                                                                                                                                              \
        echo "docker-machine not yet supported for this architecture."; exit 0;                                                                                     \
        ;;                                                                                                                                                          \
    esac;                                                                                                                                                           \
    curl -L https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-${arch_docker} >/usr/local/bin/docker-machine &&    \
    chmod +x /usr/local/bin/docker-machine && docker-machine --version


# Patch rootfs
COPY ./overlay /
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave

