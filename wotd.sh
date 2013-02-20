#!/bin/bash

type=$1
wotd=`curl --silent 'http://dictionary.reference.com/wordoftheday/wotd.rss' | grep -E '(title>|description>)' | tail -1 | sed -e 's/<description>//' -e 's/://' -e 's/<\/description>//'`

set -- $wotd

word=$1
shift
def=$@

if [ $type == 'word' ]
then
	echo "$word"
elif [ $type == 'def' ]
then
	echo "$def"
fi
