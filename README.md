# Dockerfiles

This repo is a collection of my personal Dockerfiles that I use to run my own
VPS.  It's primarily targeted at my own personal use, but I've tried to
document each Dockerfile and build script.  A short description of each
Dockerfile follows:

Name           | Short Description
---------------|--------------------------------------------------------------
ubuntu         | The base image I use for "heavyweight" containers.
ubuntu-build   | An extension of the `ubuntu` container with common build tools installed.
syncthing      | A container that runs a [syncthing](http://syncthing.net/) instance.
nginx-confd    | Nginx in a container, automatically reconfigured with [confd][confd].
sthttpd-build  | A small container that builds a statically-linked copy of [sthttpd][sthttpd].
busybox        | The [progrium/busybox][bb] container, with cURL and root CA certificates.



[sthttpd]: http://blogs.gentoo.org/blueness/2014/10/03/sthttpd-a-very-tiny-and-very-fast-http-server-with-a-mature-codebase/
[confd]: https://github.com/kelseyhightower/confd
[bb]: https://github.com/progrium/busybox
