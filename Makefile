#!/usr/bin/make
#
# title - one line synopsis
#
# @(#) $Revision: 1.2 $
# @(#) $Id: Makefile,v 1.2 2001/01/29 07:50:19 chongo Exp chongo $
# @(#) $Source: /usr/local/src/cmd/pbmtext/RCS/Makefile,v $
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

font.c: pbm.chopup.sh
	./pbm.chopup.sh > font.c

clean:
	rm -f font.bit font.c
	rm -rf fontdir

clobber: clean
	rm -f ${TARGETS}

install: all
	${INSTALL} ${TARGETS} ${DESTDIR}
