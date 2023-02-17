#!/usr/bin/env make
#
# pbmstr - form a pbm file using builtin fixed font from args
#
# Copyright (c) 2000,2023 by Landon Curt Noll.  All Rights Reserved.
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
SHELL= bash
CC= cc
INSTALL= install
DESTDIR= /usr/local/bin
TARGETS = pbmstr
RM= rm
CP= cp
CHMOD= chmod

all: ${TARGETS}

pbmstr: pbmstr.c
	${CC} pbmstr.c -o pbmstr

font.c: pbm.chopup.sh
	./pbm.chopup.sh > font.c

clean:
	${RM} -f font.bit font.c
	${RM} -rf fontdir

clobber: clean
	${RM} -f ${TARGETS}

install: all
	${INSTALL} ${TARGETS} ${DESTDIR}
