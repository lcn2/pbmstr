#!/bin/sh
#
# b64.chopup.sh - form bit patterns for the fixed font
#
# The fixed font that is builtin to pbmtext is in a 7 pixel width by
# 13 pixel high grid.  It is the 7x13 font.
#
# This prints a C source containing an array of symbols.  Each symbol is
# an array of octets.  Each octet is a for of bits.  Because the font is
# 13 pixels high, each array consists of 13 octets.  Because the font is
# 7 pixels wide, the highest order bit in each octet is unused and is set to 0.

# setup
#
ALPHABET="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/. "
ALPHASET=`echo "$ALPHABET" |
	  sed -e 's/./& /g' -e 's/\./dot/' -e 's/\//slash/' -e 's/  $/space/'`
DIR="b64dir"
rm -rf $DIR
mkdir $DIR
rm -f $DIR/tmp $DIR/b64.bit

# form the bit file
#
(pbmtext -builtin fixed "$ALPHABET" |
	pbmtoxbm |
	sed -e '1,3d' -e 's/ //g' -e 's/,//g' -e 's/};//g' \
	    -e 's/0x\(.\)\(.\)/\2\1/g' |
	tr -d '\012' |
	fold --width=118 |
	sed -e 's/0/,,,,/g' -e 's/1/,,,!/g' -e 's/2/,,!,/g' -e 's/3/,,!!/g' \
	    -e 's/4/,!,,/g' -e 's/5/,!,!/g' -e 's/6/,!!,/g' -e 's/7/,!!!/g' \
	    -e 's/8/!,,,/g' -e 's/9/!,,!/g' -e 's/a/!,!,/g' -e 's/b/!,!!/g' \
	    -e 's/c/!!,,/g' -e 's/d/!!,!/g' -e 's/e/!!!,/g' -e 's/f/!!!!/g' \
	    -e 's/\(.\)\(.\)\(.\)\(.\)/\4\3\2\1/g' \
	    -e 's/^.......//' -e 's/.......$//') |
    tail +7 |
    head -13 > b64.bit

# split the bit file into individual char files
#
cp b64.bit $DIR/b64.bit
for i in $ALPHASET; do
    sed -e 's/^\(.......\)\(.*\)$/\1/' $DIR/b64.bit > $DIR/$i.bit
    sed -e 's/^\(.......\)\(.*\)$/\2/' $DIR/b64.bit > $DIR/tmp
    mv $DIR/tmp $DIR/b64.bit
done
rm -f $DIR/tmp $DIR/b64.bit

# convert each char set into a C array
#
echo '#define ALPHABET_LEN 65		/* glyphs in alphabet + space */'
echo '#define GLYPH_PIXEL_ROWS 13	/* a symbol is this many pixels high */'
echo "unsigned char font[ALPHABET_LEN][GLYPH_PIXEL_ROWS] = {"
for i in $ALPHASET; do

    # convert to hex chars and reverse video
    #
    echo -n '    {'
    sed -e 's/\(...\)\(....\)/,\1 \2/' \
	-e 's/,,,,/f/g' -e 's/,,,!/e/g' -e 's/,,!,/d/g' -e 's/,,!!/c/g' \
	-e 's/,!,,/b/g' -e 's/,!,!/a/g' -e 's/,!!,/9/g' -e 's/,!!!/8/g' \
	-e 's/!,,,/7/g' -e 's/!,,!/6/g' -e 's/!,!,/5/g' -e 's/!,!!/4/g' \
	-e 's/!!,,/3/g' -e 's/!!,!/2/g' -e 's/!!!,/1/g' -e 's/!!!!/0/g' \
	-e 's/ //' -e 's/^.*/0x&,/' $DIR/$i.bit | 
	tr -d '\012' | sed -e 's/,$//'
    echo '}, /* '$i' */'
done | sed -e '$s/}, \//}  \//'
echo '};'
