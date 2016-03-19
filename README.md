# Docker image on Scaleway
[![Build Status](https://travis-ci.org/scaleway-community/scaleway-docker.svg?branch=master)](https://travis-ci.org/scaleway-community/scaleway-docker)
[![Scaleway ImageHub](https://img.shields.io/badge/ImageHub-view-ff69b4.svg)](https://hub.scaleway.com/docker.html)
[![Run on Scaleway](https://img.shields.io/badge/Scaleway-run-69b4ff.svg)](https://cloud.scaleway.com/#/servers/new?image=c1b530d8-0ca0-45c4-80db-ba06608287b2)


Launch your Docker app on Scaleway servers in minutes.

<img src="http://stratechery.com/wp-content/uploads/2014/12/docker.png" width="400px" />

---

## How to hack

**This image is meant to be used on a Scaleway server.**

We use the Docker's building system and convert it at the end to a disk image that will boot on real servers without Docker. Note that the image is still runnable as a Docker container for debug or for inheritance.

[More info](https://github.com/scaleway/image-builder)

---

## Links

- Compatible images
  - [Docker Hub: "armbuild"](https://hub.docker.com/search/?q=armbuild&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
  - [Docker Hub: "hypriot"](https://hub.docker.com/search/?q=hypriot&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
  - [Docker Hub: "armhf"](https://hub.docker.com/search/?q=armhf&page=1&isAutomated=0&isOfficial=0&starCount=0&pullCount=0)
- [Hypriot Blog: Docker on Raspberry PI (compatible with Scaleway)](http://blog.hypriot.com)
- [Community: Docker Support](https://community.cloud.online.net/t/official-docker-support/374?u=manfred)
- [Community: Getting started with Docker on C1 (armhf)](https://community.cloud.online.net/t/getting-started-docker-on-c1-armhf/383?u=manfred)
- [Online Labs Blog - Docker on C1](https://blog.cloud.online.net/2014/10/27/docker-on-c1/)

---

A project by [![Scaleway](https://avatars1.githubusercontent.com/u/5185491?v=3&s=42)](https://www.scaleway.com/)
