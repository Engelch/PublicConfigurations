#!/usr/bin/env bash

[ "$1" = -v -o "$1" = --verbose ] && verbose=--verbose && shift
if [ -z "$1" ] ; then
  command=patch
else
  command=$1
fi
# syntactic sugar
[ $command = p ] && command=patch
[ $command = m ] && command=minor
[ $command = mi ] && command=minor
[ $command = ma ] && command=major

declare -r version=${INCREASEVERSION_FILE:-version.txt}
[ ! -f $version ] && echo ERROR: no version file $version detected. 1>&2 && exit 1
bumpversion $verbose --current-version $(cat $version| grep -v ^$ | grep -v '^#' | head -n1 | sed 's/#.*//') $command $version
