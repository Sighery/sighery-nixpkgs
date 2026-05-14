#!/usr/bin/env sh

if [ -z "$1" ]; then
	echo "Provide a filepath" >&2
	exit -1
fi

in=$1

case "$1" in
	*.png | *.jpg | *.jpeg) xclip -selection clipboard -t image/png -i "$1" ;;
	*) xclip -selection clipboard -i "$1" ;;
esac

exit 0
