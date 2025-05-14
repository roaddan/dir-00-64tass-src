!/bin/bash
cd /Users/Locals/C64/00-usbkey32go/d-00-64tass-src
#export unedate="$(/bin/date "+%Y%m%d-%H%M%S")"
export ladate=$(/bin/date "+%Y%m%d-%H%M%S")
export unedate="Mis à jour par D.L.: ${ladate}."
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
#		git commit -m $(/bin/date "+%Y%m%d-%H%M%S")
		git commit -m "${unedate}"
		git push -u origin main
		;;
esac

