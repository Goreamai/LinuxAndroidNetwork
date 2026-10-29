SHELL := /bin/sh

ROOTFS := build/rootfs
PREFIX := $(ROOTFS)/usr/lib/nexus

.PHONY: all test stage magisk-package clean

all: test

test:
	sh tests/test_config.sh
	sh tests/test_health.sh
	sh tests/test_tunnel.sh

stage:
	rm -rf build
	mkdir -p "$(PREFIX)" "$(ROOTFS)/etc/nexus" "$(ROOTFS)/etc/init.d"
	cp -R services/. "$(PREFIX)/"
	cp configs/nexus.conf.example "$(ROOTFS)/etc/nexus/nexus.conf"
	cp packaging/init.d/nexus "$(ROOTFS)/etc/init.d/nexus"
	chmod 0755 "$(PREFIX)"/*.sh "$(ROOTFS)/etc/init.d/nexus"
	printf '%s\n' "staged $(ROOTFS)"

magisk-package:
	sh packaging/magisk/build.sh

clean:
	rm -rf build
