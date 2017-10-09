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
	WGET=`which wget`

	urlString1=$1
	urlString2=$2
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
	printf "\t\tfollow suit.\n"

	exit 1
}

determine_numbering_scheme() {
	#well, fugly, but this _is_ shellscript, and it _is_ POSIX compliant
	minStartChar=$(echo "$min" | fold -w1 | head -n 1)

	if [ "$minStartChar" = "0" ]; then
		prep0=$TRUE
	else
		prep0=$FALSE
	fi

	return "$prep0"
}

#main script entry
init $1 $2 $3 $4

if [ $# -ne 4 ] ; then
	usage
fi

determine_numbering_scheme $min
leading_zero=$?

#are we going to have issues with $max if it's had a '0' prepended by the user
#as well?

for cntr in $(seq $min $max) ; do
	#if num is parsed straight from the command line we may need to prune
	#the '0' that we just determined the potential leading zero on
	if [ $leading_zero -eq $TRUE ] ; then
		if [ $cntr -lt 10 ] ; then
			#so yeah, no double zeros here
			num="0$cntr"
		else
			num=$cntr
		fi
	else
		num=$cntr
	fi

	completeURL="${urlString1}${num}${urlString2}"
	#okay, so now $completeURL is ending up in all lower case?  wtf
	$WGET $completeURL
done

