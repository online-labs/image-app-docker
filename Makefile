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
	mkdir -p overlay-$(TARGET_UNAME_ARCH)/usr/bin tmp

	# build nsenter
	# disabled for now, there are bugs with the current ./configure script and the crossbuild image
	#cd tmp; wget -N https://www.kernel.org/pub/linux/utils/util-linux/v2.26/util-linux-2.26.tar.gz
	#rm -rf tmp/util-linux-2.26
	#cd tmp; tar -xf util-linux-2.26.tar.gz
	#ln -sf util-linux-2.26 tmp/util-linux
	#docker run --rm -it -e CROSS_TRIPLE=$(TARGET_UNAME_ARCH) -v $(shell pwd)/tmp/util-linux:/workdir multiarch/crossbuild sh -xec ' \
	#  ./configure --without-ncurses && \
	#  make LDFLAGS=-all-static nsenter \
	#'
	docker run --rm -v $(shell pwd)/overlay-x86_64/usr/bin/:/target jpetazzo/nsenter || true
	  
	# fetch docker-enter
	wget https://raw.githubusercontent.com/jpetazzo/nsenter/master/docker-enter -NO overlay-$(TARGET_UNAME_ARCH)/usr/bin/docker-enter

	# build importenv
	cd tmp; wget -N https://github.com/jpetazzo/nsenter/raw/master/importenv.c
	rm -f tmp/importenv
	docker run --rm -it -e CROSS_TRIPLE=$(TARGET_UNAME_ARCH) -v $(shell pwd)/tmp:/workdir multiarch/crossbuild cc -static -o importenv importenv.c
	mv tmp/importenv overlay-$(TARGET_UNAME_ARCH)/usr/bin/


update_swarm:
	mkdir -p overlay-$(TARGET_UNAME_ARCH)/usr/bin tmp
	docker run \
	  -it --rm -e GO15VENDOREXPERIMENT=1 -w $(PWD)/tmp:/host \
	  multiarch/goxc \
	  sh -xec '\
	    go get -u -v github.com/docker/swarm || true; \
	    goxc -bc="linux,$(TARGET_GOLANG_ARCH)" -wd /go/src/github.com/docker/swarm -d /host -pv tmp xc \
	  '
