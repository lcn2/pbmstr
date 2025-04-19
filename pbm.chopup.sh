#!/usr/bin/env bash
#
# pbm.chopup.sh - form bit patterns for the fixed font
#
# NOTE: This tool was used to create font table used in pbmstr.c file.
#	It is left behind for "historical" purposes.
#
# The fixed font that is builtin to pbmstr is in a 7 pixel width by
# 13 pixel high grid.  It is the 7x13 font.
#
# This prints a C source containing an array of symbols.  Each symbol is
# an array of octets.  Each octet is a for of bits.  Because the font is
# 13 pixels high, each array consists of 13 octets.  Because the font is
# 7 pixels wide, the highest order bit in each octet is unused and is set to 0.
#
# Copyright (c) 2000-2001,2015,2023,2025 by Landon Curt Noll.  All Rights Reserved.
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
# chongo (Landon Curt Noll) /\oo/\
#
# http://www.isthe.com/chongo/index.html
# https://github.com/lcn2
#
# Share and enjoy!  :-)


# setup
#
ALPHABET=' !"#$%&'"'"'()*+,-./0123456789:;<=>?@ABCDEFGHJIKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~'
DIR="fontdir"
rm -rf "$DIR"
mkdir -p "$DIR"
rm -f "$DIR/tmp" "$DIR/font.bit"

# form the bit file
#
(pbmtext -builtin fixed "$ALPHABET" |
	pbmtoxbm |
	sed -e '1,3d' -e 's/ //g' -e 's/,//g' -e 's/};//g' \
	    -e 's/0x\(.\)\(.\)/\2\1/g' |
	tr -d '\012' |
	fold --width=170 |
	sed -e 's/0/,,,,/g' -e 's/1/,,,!/g' -e 's/2/,,!,/g' -e 's/3/,,!!/g' \
	    -e 's/4/,!,,/g' -e 's/5/,!,!/g' -e 's/6/,!!,/g' -e 's/7/,!!!/g' \
	    -e 's/8/!,,,/g' -e 's/9/!,,!/g' -e 's/a/!,!,/g' -e 's/b/!,!!/g' \
	    -e 's/c/!!,,/g' -e 's/d/!!,!/g' -e 's/e/!!!,/g' -e 's/f/!!!!/g' \
	    -e 's/\(.\)\(.\)\(.\)\(.\)/\4\3\2\1/g' \
	    -e 's/^.......//' -e 's/.......$//') |
    tail +7 |
    head -13 > font.bit

# split the bit file into individual char files
#
cp font.bit "$DIR/font.bit"
j=0
while [[ "$j" -lt 95 ]]; do
    if [[ "$j" -lt 10 ]]; then
	file="font0$j.bit"
    else
	file="font$j.bit"
    fi
    sed -e 's/^\(.......\)\(.*\)$/\1/' "$DIR/font.bit" > "$DIR/$file"
    sed -e 's/^\(.......\)\(.*\)$/\2/' "$DIR/font.bit" > "$DIR/tmp"
    mv "$DIR/tmp" "$DIR/font.bit"
    ((j++))
done
rm -f "$DIR/tmp" "$DIR/font.bit"

# convert each char set into a C array
#
echo '#define ALPHABET_LEN 256		/* glyphs in alphabet + space */'
echo '#define GLYPH_PIXEL_ROWS 13	/* a symbol is this many pixels high */'
echo "unsigned char font[ALPHABET_LEN][GLYPH_PIXEL_ROWS] = {"
j=0
while [[ "$j" -lt 32 ]]; do
    echo -n "   {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,"
    echo "0xff}, /* $j */"
    ((j++))
done
j=0
while [[ "$j" -lt 95 ]]; do

    # convert to hex chars and reverse video
    #
    if [[ "$j" -lt 10 ]]; then
	file="font0$j.bit"
    else
	file="font$j.bit"
    fi
    ((k = j + 32))
    echo -n '   {'
    sed -e 's/\(...\)\(....\)/,\1 \2/' \
	-e 's/,,,,/f/g' -e 's/,,,!/e/g' -e 's/,,!,/d/g' -e 's/,,!!/c/g' \
	-e 's/,!,,/b/g' -e 's/,!,!/a/g' -e 's/,!!,/9/g' -e 's/,!!!/8/g' \
	-e 's/!,,,/7/g' -e 's/!,,!/6/g' -e 's/!,!,/5/g' -e 's/!,!!/4/g' \
	-e 's/!!,,/3/g' -e 's/!!,!/2/g' -e 's/!!!,/1/g' -e 's/!!!!/0/g' \
	-e 's/ //' -e 's/^.*/0x&,/' "$DIR/$file" | 
	tr -d '\012' | sed -e 's/,$//'
    echo "}, /* $k */"
    ((j++))
done
j=127
while [[ "$j" -lt 256 ]]; do
    echo -n "   {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,"
    echo "0xff}, /* $j */"
    ((j++))
done | sed -e '$s/}, \//}  \//'
echo '};'
