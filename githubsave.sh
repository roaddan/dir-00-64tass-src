#!/bin/bash
export unedate="$(/bin/date "+%Y%m%d-%H%M%S")"
echo ${unedate}
case $1 in
	status)
		echo ${unedate}
		git status
		;;
	pull)
		git pull origin main
		;;
	*)
		git add .
		git commit -m $(/bin/date "+%Y%m%d-%H%M%S")
		git push -u origin main
		;;
esac

