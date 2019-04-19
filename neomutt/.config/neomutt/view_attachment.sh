#!/usr/bin/env bash
#

# the tmp directory to use.
tmpdir="$HOME/.config/neomutt/tmp/mutt_attach"

# make sure the tmpdir exists.
mkdir -p $tmpdir

# clean it out.  Remove this if you want the directory
# to accumulate attachment files.
rm -rf $tmpdir/*

# Mutt puts everything in /tmp by default.
# This gets the basic filename from the full pathname.
filename=`basename $1`

# get rid of the extenson and save the name for later.
#file=`echo $filename | cut -d"." -f1`
file=`echo $filename | sed 's/\.[^.]*$//'`
newfile=$tmpdir/$filename

# Copy the file to our new spot so mutt can't delete it
# before the app has a chance to view it.
cp $1 $newfile

# If there's no 'open with' then we can let preview do it's thing.
# Otherwise we've been told what to use.  So do an open -a.

o=`uname -s`
if [[ "${o,,}" == "darwin" ]] ;then
    if [ -z $2 ]; then
        open $newfile
    else
        open -a "$open_with" $newfile
    fi
elif [[ "${o,,}" == "linux" ]] ;then
    setsid xdg-open "$newfile" >/dev/null 2>&1 &
fi
