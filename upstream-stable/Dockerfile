## -*- docker-image-name: "scaleway/docker" -*-
ARG SCW_ARCH
FROM scaleway/ubuntu:${SCW_ARCH}-xenial


MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)


# Prepare rootfs for image-builder
RUN /usr/local/sbin/builder-enter


# Install packages
RUN apt-get -q update                   \
 && apt-get install -y -q               \
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
      gosu                              \
      apt-transport-https               \
      software-properties-common        \
      jq                                \
 && apt-get clean


# Install Docker
RUN (curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -)
RUN add-apt-repository "deb https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -q -y docker-ce docker-compose


# Install Docker Machine
RUN case "$(uname -m)" in                                                                                                                                                 \
        x86_64) arch_docker=x86_64;;                                                                                                                                  \
        arm64) arch_docker=aarch64;;                                                                                                                                  \
        armhf) arch_docker=armhf;;                                                                                                                                    \
        *) echo "docker-machine not yet supported for this architecture."; exit 0;;                                                                                   \
    esac;                                                                                                                                                             \
    MACHINE_REPO=https://api.github.com/repos/docker/machine/releases/latest;                                                                                         \
    MACHINE_URL=$(curl -s -L $MACHINE_REPO | jq -r --arg n "docker-machine-Linux-${arch_docker}" '.assets[] | select(.name | contains($n)) | .browser_download_url'); \
    curl -s -L $MACHINE_URL >/usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine


# Install Pipework
RUN wget -qO /usr/local/bin/pipework https://raw.githubusercontent.com/jpetazzo/pipework/master/pipework  \
 && chmod +x /usr/local/bin/pipework


# Patch rootfs
COPY ./overlay /
RUN systemctl enable docker


# Clean rootfs from image-builder
RUN /usr/local/sbin/builder-leave
