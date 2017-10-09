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
	echo "Usage:\t$0 urlString1 urlString2 min max"
	echo "\t\tConcats urlString1 + (min <= ep# <=max) + urlString2"
	echo "\t\tfor wgetting each successive URL; if the min value"
	echo "\t\tcontains a preceding '0', all single digit numbers will"
    echo "\t\tfollow suit."

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

if [ $# -eq 0 ] ; then
	if [ $# -ne 4 ] ; then
		dump_usage
	fi
fi

determine_numbering_scheme $min
leading_zero=$?

for cntr in $(seq $min $max) ; do
	if [ $leading_zero -eq $TRUE ] ; then
		num="0$cntr"
	else
		num=$cntr
	fi

	completeURL="${urlString1}${num}${urlString2}"
	$WGET $completeURL
done

