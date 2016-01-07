NAME =			docker
VERSION =		latest
VERSION_ALIASES =	1.9.1 1.9 1
TITLE =			Docker
DESCRIPTION =		Docker + Docker-Compose + gosu + nsenter + pipework
SOURCE_URL =		https://github.com/scaleway-community/scaleway-docker
DEFAULT_IMAGE_ARCH =	x86_64

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	docker
IMAGE_NAME =		Docker 1.9.1


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
## Here you can add custom commands and overrides


update_nsenter:
	mkdir -p overlay-${ARCH}
	docker run --rm -v $(PWD)/overlay-${ARCH}/usr/bin:/target armbuild/jpetazzo-nsenter

update_swarm:
	mkdir -p overlay-$(ARCH)/usr/bin
	go get -u github.com/docker/swarm || true
	go get github.com/laher/goxc
	goxc -t -bc="linux,$(TARGET_GOLANG_ARCH)"
	GO15VENDOREXPERIMENT=1 goxc -bc="linux,$(TARGET_GOLANG_ARCH)" -wd $(GOPATH)/src/github.com/docker/swarm -d . -pv tmp xc
	mv tmp/linux_$(TARGET_GOLANG_ARCH)/swarm overlay-$(ARCH)/usr/bin/swarm
