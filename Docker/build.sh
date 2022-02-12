#!/bin/bash

# dry-run 
[ "$1" = -n ] && dry=echo && echo DRY RUN ONLY.
name=$(basename $PWD | sed -e 's/ /_/g' | tr [A-Z] [a-z])
echo Building image $name...
$dry docker build -t $name .
