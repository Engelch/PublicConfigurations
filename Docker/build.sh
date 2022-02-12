#!/bin/bash

# dry-run 
[ "$1" = -n ] && dry=echo && echo DRY RUN ONLY.
name=$(basename $PWD | sed -e 's/ /_/g' | tr [A-Z] [a-z])
if [ -r .version ] ; then
    version=":"$(cat .version | grep -v '^$')
    echo version is $version
fi
echo Building image $name$version...
$dry docker build -t $name$version .
