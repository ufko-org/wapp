#!/usr/bin/make
#
# Makefile for wapptclsh on unix.  Usage:
#
#    make clean wapptclsh TCLDIR=/home/drh/local
#
# You need a static build of TCL9 in the directory that TCLDIR specifies.
# To construct such a build:
#
#    (1)  Download and untar the TCL9 sources
#    (2)  CD into the unix subdirectory
#    (3)  ./configure --disable-shared --prefix=/home/drh/local
#                        change as appropriate -^^^^^^^^^^^^^^^
#    (4)  make install
#

CFLAGS = -Os -static
CC = cc $(CFLAGS)
OPTS = -DSQLITE_ENABLE_DESERIALIZE
TCLDIR ?= /home/ivan/app/tcl
TCLLIB = $(TCLDIR)/lib/libtcl90.a -lm -lz -lpthread
TCLINC = $(TCLDIR)/include
TCLSH = $(TCLDIR)/bin/tclsh9.0

all: wapptclsh

wapptclsh: wapptclsh.c
	$(CC) -I. -I$(TCLINC) -o $@ $(OPTS) wapptclsh.c $(TCLLIB)

wapptclsh.c:	wapptclsh.c.in wapp.tcl app.tcl markdown.tcl wapptclsh.tcl tclsqlite3.c mkccode.tcl
	$(TCLSH) mkccode.tcl wapptclsh.c.in >$@

clean:	
	rm -f wapptclsh wapptclsh.c
