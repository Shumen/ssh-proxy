#!/usr/bin/make -f
### Makefile 
###
### Create:   2009-12-17
### Updated:  2012-06-21
### 

PACKAGE?=ssh-proxy
#URL=http://www.meadowy.org/~gotoh/projects/connect/browser/trunk/connect.c?format=raw
#URL=http://www.meadowy.org/~gotoh/ssh/connect.c
URL=https://bitbucket.org/gotoh/connect/raw/default/connect.c
INSTALL_DIR?=${DESTDIR}/usr
OBJS?=connect.o

UNAME := $(shell uname -s)
WINVER := $(shell ver)

CC=gcc
CFLAGS=
LDLIBS=

## for Mac OS X environment, use one of options
ifeq ($(UNAME), Darwin)
	CFLAGS=-DBIND_8_COMPAT=1
	LDLIBS=-lresolv
endif

## for Solaris
ifeq ($(UNAME), SunOS)
	LDLIBS=-lresolv -lsocket -lnsl
endif

## for Microsoft Windows native
ifeq ($(findstring Windows, ${WINVER}), Windows)
    ifeq (${CC}, clang)
	CFLAGS=-ccc-gcc-name llvm-gcc.exe
	LDLIBS=-ccc-gcc-name llvm-gcc.exe
    endif
    LDLIBS := ${LDLIBS} -lws2_32 -liphlpapi
endif

all default: ${PACKAGE}

install: ${PACKAGE}
	-mkdir -p ${INSTALL_DIR}/bin/
	install ${PACKAGE} ${INSTALL_DIR}/bin/
#	ln -fs ${PACKAGE} ${INSTALL_DIR}/bin/connect

${PACKAGE}: ${OBJS}
	    ${CC} -o $@ $^ ${LDFLAGS} 

# connect.c:
#	wget -O $@ "${URL}"

update:
	wget -O connect.c "${URL}"

LICENCE: /usr/share/apps/LICENSES/GPL_V2
	ln -fs $^ $@

##

clean:
	${RM} ${PACKAGE}.o *~ ${OBJS} || echo "# $@: $^"
veryclean: clean
	${RM} ${PACKAGE} ${PACKAGE}.exe || echo "# $@: $^"
rebuild: veryclean all

### End of Makefile
