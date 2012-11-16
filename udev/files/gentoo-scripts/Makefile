PACKAGE = udev-init-scripts
VERSION = 8
DISTNAME = $(PACKAGE)-$(VERSION)

LIBUDEV ?= /lib/udev
RULESDIR ?= $(LIBUDEV)/rules.d
SYSCONFDIR ?= /etc
CONFD ?= $(SYSCONFDIR)/conf.d
INITD ?= $(SYSCONFDIR)/init.d
MODPROBE_DIR ?= $(SYSCONFDIR)/modprobe.d

HELPERS = \
	helpers/net.sh \
	helpers/write_root_link_rule

all:
	@echo "Run make install DESTDIR="

install:
	@install -d $(DESTDIR)$(LIBUDEV)
	@install -m 0755 $(HELPERS) $(DESTDIR)$(LIBUDEV)
	@install -d $(DESTDIR)$(RULESDIR)
	@install -m 0644 rules.d/??-*.rules $(DESTDIR)$(RULESDIR)
	@install -d $(DESTDIR)$(CONFD)
	@install -m 0644 conf.d/* $(DESTDIR)$(CONFD)
	@install -d $(DESTDIR)$(INITD)
	@install -m 0755 init.d/* $(DESTDIR)$(INITD)
	@install -d $(DESTDIR)$(MODPROBE_DIR)
	@install -m 0644 modprobe.d/* $(DESTDIR)$(MODPROBE_DIR)

check-git-repository:
	git diff --quiet || { echo 'STOP, you have uncommitted changes in the working directory' ; false ; }
	git diff --cached --quiet || { echo 'STOP, you have uncommitted changes in the index' ; false ; }

check test:
	@cd test; ./run_test.sh

dist:
	git archive --format=tar --prefix=$(DISTNAME)/ $(VERSION) | \
		bzip2 > $(DISTNAME).tar.bz2

snapshot: check-git-repository
	git archive --format=tar --prefix=$(PACKAGE)/ HEAD | \
		bzip2 > $(PACKAGE).tar.bz2

.PHONY: install test

