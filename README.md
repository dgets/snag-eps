# snag-eps

Just a little shell script that will automate snagging of multiple episodes of a series that has sequential similar filenames from a web host.  I may end up adding support for ftp protocol and directory mirroring at some point.  It'd also be nice to have some sed work that'll handle things so that we only need one complete URL.  Can't be too hard to construct them from such.

## Update (1 Nov 17)

Though I was very excited to be trying to handle this project strictly in shell script, some of the limitations that I'm starting to bang my head into are really making me wonder. I may just push this version of the code forward until I've completed the sed work (with automatic URL parsing), and then abandon it for a python version. I can't remember python for the life of me, and I know that it's had serious changes... I enjoyed it when I used it quite awhile ago, though. Still, when I can only remember that it's different because of whitespace being important, that's not good. Maybe Ruby would be a better idea, since I've used that more recently. I'll have to put some thought into it, I guess.

