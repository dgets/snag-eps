#!/bin/sh
#
#by Damon Getsman
#start: 6 Oct 17
#
#Just a little script that will automate snagging of multiple episodes of a
#series that has sequential similar filenames from a web host.  I may end up
#adding support for ftp protocol and directory mirroring at some point.  It'd
#also be nice to have some sed work that'll handle things so that we only need
#one complete URL.  Can't be too hard to construct them from that.

#not worrying about support for multiple seasons in one directory yet

dump_usage() {
	echo Usage:\t$0 urlString1 urlString2 min max
	echo \t\tConcats urlString1 + \(min \<= ep\# \<=max\) + urlString2
	echo \t\tfor wgetting each successive URL
}

#main script entry
if [ ($# -eq 0) || ($# -ne 4) ] ; then
	dump_usage
fi


