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
 && apt-get --force-yes -y -qq upgrade  \
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
RUN case "${ARCH}" in                                                                                 \
    armv7l|armhf|arm)                                                                                 \
      curl -Ls https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.12.1-0~jessie_armhf.deb > docker.deb && \
      dpkg -i docker.deb &&                                                                           \
      rm docker.deb;                                                                                  \
      ;;                                                                                              \
    amd64|x86_64|i386)                                                                                \
      curl -L https://get.docker.com/ | sh;                                                           \
      ;;                                                                                              \
    *)                                                                                                \
      echo "Unhandled architecture: ${ARCH}."; exit 1;                                                \
      ;;                                                                                              \
    esac                                                                                              \
 && docker --version


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework  \
 && chmod +x /usr/local/bin/pipework


# Install Gosu
ENV GOSU_VERSION=1.9
RUN case "${ARCH}" in                                                                                                \
    armv7l|armhf|arm)                                                                                                \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-armhf &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
      ;;                                                                                                             \
    aarch64|arm64)                                                                                                   \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-arm64 &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
      ;;                                                                                                             \
    x86_64|amd64)                                                                                                    \
        wget -qO /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64 &&  \
        chmod +x /usr/local/bin/gosu;                                                                                \
       	;;                                                                                                           \
    *)                                                                                                               \
       	echo "Unhandled architecture: ${ARCH}."; exit 1;                                                             \
      ;;                                                                                                             \
    esac                                                                                                             \
 && ( gosu --version || true )



# Install Docker Compose
RUN easy_install -U pip                                     \
 && pip install docker-compose                              \
 && ln -s /usr/local/bin/docker-compose /usr/local/bin/fig  \
 && docker-compose --version


# Install Docker Machine
ENV DOCKER_MACHINE_VERSION=0.8.1
RUN case "${ARCH}" in                                                                                                                                        \
    x86_64|amd64|i386)                                                                                                                                       \
        curl -L https://github.com/docker/machine/releases/download/v${DOCKER_MACHINE_VERSION}/docker-machine-Linux-x86_64 >/usr/local/bin/docker-machine && \
        chmod +x /usr/local/bin/docker-machine &&                                                                                                            \
       	docker-machine --version;                                                                                                                            \
      ;;                                                                                                                                                     \
    *)                                                                                                                                                       \
       	echo "docker-machine not yet supported for this architecture."                                                                                       \
      ;;                                                                                                                                                     \
    esac


# Patch rootfs
COPY ./overlay /
RUN systemctl disable docker; systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave

