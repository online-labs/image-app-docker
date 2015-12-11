NAME =			docker
VERSION =		latest
VERSION_ALIASES =	1.9.1 1.9 1
TITLE =			Docker
DESCRIPTION =		Docker + Docker-Compose + gosu + nsenter + pipework
SOURCE_URL =		https://github.com/scaleway-community/scaleway-docker

IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	docker
IMAGE_NAME =		Docker 1.9.1


## Image tools  (https://github.com/scaleway/image-tools)
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
	sed -i -e "s/mkfs.ext4/mkfs.btrfs -f -O ^extref,^skinny-metadata/1" docker-rules.mk

-include docker-rules.mk
## Here you can add custom commands and overrides


update_nsenter:
	docker run --rm -v $(PWD)/patches/usr/bin:/target armbuild/jpetazzo-nsenter

update_swarm:
	go get -u github.com/docker/swarm
	cd $(GOPATH)/src/github.com/docker/swarm/ && GOOS=linux GOARCH=arm GOARM=7 go build -a -v -ldflags '-d -w -s' -o $(PWD)/patches/usr/bin/swarm
