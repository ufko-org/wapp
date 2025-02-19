#!/usr/bin/make

# This Makefile is for OpenBSD. There is no libdl. -ldl removed from linking.
# See Makefile.orig

CFLAGS = -Os -static
CC = cc $(CFLAGS)
OPTS = -DSQLITE_ENABLE_DESERIALIZE
TCLDIR ?= /home/${USER}/app/tcl
TCLLIB = $(TCLDIR)/lib/libtcl90.a -lm -lz -lpthread
TCLINC = $(TCLDIR)/include
TCLSH = $(TCLDIR)/bin/tclsh9.0

all: wapptclsh

wapptclsh: wapptclsh.c
	$(CC) -I. -I$(TCLINC) -o $@ $(OPTS) wapptclsh.c $(TCLLIB)
	strip $@

wapptclsh.c:	wapptclsh.c.in wapp.tcl app.tcl markdown.tcl wapptclsh.tcl tclsqlite3.c mkccode.tcl
	$(TCLSH) mkccode.tcl wapptclsh.c.in >$@

clean:	
	rm -f wapptclsh wapptclsh.c
