#!/usr/bin/env bash

# the tmp directory to use.
tmpdir="$XDG_CACHE_HOME/mutt/view_attachment"

# make sure the tmpdir exists.
mkdir -p $tmpdir

# clean it out.  Remove this if you want the directory
# to accumulate attachment files.
rm -rf $tmpdir/*

# Mutt puts everything in /tmp by default.
# This gets the basic filename from the full pathname.
filename=`basename $1`

# get rid of the extenson and save the name for later.
newfile=$tmpdir/$filename

# Copy the file to our new spot so mutt can't delete it
# before the app has a chance to view it.
cp $1 $newfile

# If there's no 'open with' then we can let preview do it's thing.
# Otherwise we've been told what to use.  So do an open -a.
if [ -z $2 ]; then
    open $newfile
else
    open -a "$open_with" $newfile
fi
