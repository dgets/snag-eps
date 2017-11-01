#!/bin/sh
#
#by Damon Getsman
#start: 6 Oct 17
#
#Just a little script that will automate snagging of multiple files of a
#series that has sequential similar filenames from a web host.  I may end up
#adding support for ftp & directory mirroring at some point.  It'd also be nice
#to have some sed work that'll handle things so that we only need one complete
#URL.  Can't be too hard to construct them from that.

init() {
	TRUE=1
	FALSE=0
	
	PRIMITIVE=0
	AUTOSPLIT=1

	DEBUGGING=$TRUE
	#VERBOSE=$FALSE
	WGET=$(which wget)

	return
}

init0() {
	#used for 'primitive' mode (no autosplit)
	urlString1=$1
	urlString2=$2
	min=$3
	max=$4

	return
}

init1() {
	#autosplit mode
	urlString=$1
	delimitChar=$2
	min=$3
	max=$4

	return
}

usage() {
	#so yeah, this description is wrong; must've been haigh
	printf "Usage:\t%s urlString1 urlString2 min max\n" "$0"
	printf "\t\tConcats urlString1 + (min <= ep# <=max) + urlString2\n"
	printf "\t\tfor wgetting each successive URL; if the min value\n"
	printf "\t\tcontains a preceding '0', all single digit numbers will\n"
	printf "\t\tfollow suit.\n\n"

	if [ $DEBUGGING -eq $TRUE ] ; then
		printf "Debugging:\n"
		printf "Usage:\t%s -n urlString delimiter min max\n" "$0"
		printf "\t\tNew usage; splits urlString using delimiter & "
		printf "min.\n"
	fi

	exit 1
}

determine_numbering_scheme() {
	#well, fugly, but this _is_ shellscript, and it _is_ POSIX compliant
	minStartChar=$(echo "$min" | fold -w1 | head -n 1)

	if [ $DEBUGGING -eq $TRUE ] ; then
		echo "\$minStartChar: $minStartChar"
	fi

	if [ "$minStartChar" = "0" ]; then
		prep0=$TRUE
	else
		prep0=$FALSE
	fi

	return "$prep0"
}

determine_mode() {
	#NOTE: whilst determining the mode that we're running, this function
	#also executes 'usage' for any invocation errors

	if [ $# -ne 4 ] ; then
		if [ $DEBUGGING -eq $TRUE ] ; then
			if [ $# -eq 5 ] ; then
				if [ $1 != "-n" ] ; then
					usage
				else
					mode=$AUTOSPLIT
					init1
				fi
			else
				usage
			fi
		else
			usage
		fi
	else
		#this line makes me think it's time to add a verbose flag :P
		mode=$PRIMITIVE
		#init0

		if [ $DEBUGGING -eq $TRUE ] ; then
			echo -n "$1 - $2 "
			echo "- $3 - $4"
		fi
	fi

	return $mode
}

#main script entry
init 	#"$1" "$2" "$3" "$4"	#previous combined init()
determine_mode	"$1" "$2" "$3" "$4"

if [ $? -eq $PRIMITIVE ] ; then
	if [ $DEBUGGING -eq $TRUE ] ; then
		echo "Primitive mode"
	fi

	init0 "$1" "$2" "$3" "$4"
else	#autosplit
	if [ $DEBUGGING -eq $TRUE ] ; then
		echo "Autosplit mode"
	fi

	init1 "$2" "$3" "$4" "$5"	#first is the flag, ouah
fi

determine_numbering_scheme
leading_zero=$?

counter=$((min))
while [ $counter -le $((max)) ]; do
	#if num is parsed straight from the command line we may need to prune
	#the '0' that we just determined the potential leading zero on
	if [ $leading_zero -eq $TRUE ] && [ $counter -lt 10 ] ; then
		#so yeah, no double zeros here
		num="0$counter"
	else
		num=$counter
	fi

	completeURL="${urlString1}${num}${urlString2}"
	if [ $DEBUGGING -eq $TRUE ] ; then
		echo Unquoted: ${urlString1}${num}${urlString2}
	fi

	$WGET $completeURL
	counter=$((counter + 1))
done
