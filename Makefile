#!/usr/bin/make
#
# title - one line synopsis
#
# @(#) $Revision: 1.1 $
# @(#) $Id: Makefile,v 1.1 2001/01/27 19:18:20 chongo Exp chongo $
# @(#) $Source: /usr/local/src/cmd/pbmtext8x13/RCS/Makefile,v $
#
# Copyright (c) 2000 by Landon Curt Noll.  All Rights Reserved.
#
# Permission to use, copy, modify, and distribute this software and
# its documentation for any purpose and without fee is hereby granted,
# provided that the above copyright, this permission notice and text
# this comment, and the disclaimer below appear in all of the following:
#
#       supporting documentation
#       source copies
#       source works derived from this source
#       binaries derived from this source or from derived source
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# chongo <was here> /\oo/\
#
# Share and enjoy!

# common prep
#
SHELL= /bin/sh
CC= cc
INSTALL= install
DESTDIR= /usr/local/bin
TARGETS = pbmtext

all: ${TARGETS}

pbmtext: pbmtext.c
	${CC} pbmtext.c -o pbmtext

b64.c: b64.chopup.sh
	./b64.chopup.sh > b64.c

clean:
	rm -f b64.bit b64.c
	rm -rf b64dir

clobber: clean
	rm -f ${TARGETS}

install: all
	${INSTALL} ${TARGETS} ${DESTDIR}
