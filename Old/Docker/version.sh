#!/usr/bin/env bash

# -d as debug option to show if the correct line is identified
# without -d, the line is reduced to the pure version number.

appDir=$(dirname $0)
cd "$appDir"
[ $(pwd | xargs basename) = bin ] && cd .. # correct location if binary in bin

if [ -f "$appDir/versionFilePattern" ] ; then
   _versionFilePattern=$(cat "$appDir/versionFilePattern" | grep -v '^$' | egrep -v '^[[:space:]]*#' | sed 's/[[:space:]]*#.*$//')
   START="egrep '' $_versionFilePattern /dev/null | grep -v '^$' | egrep -v '^[[:space:]]*#'"
else
   _versionFilePattern='*.go'
   START="egrep -i$_egrepFlag 'app(\.)?Version[[:space:]]*=' $_versionFilePattern /dev/null | egrep '[0-9]+\.[0-9]+\.[0-9]+' | tail -n1"
fi


if [ "$1" = -d ] ; then
   eval $START
else
   appVersion=$(eval $START | sed 's/^.*=//' | sed 's/\"//g' | sed 's,//.*,,' | sed 's/[[:space:]]//g' | sed 's/^-//' | sed 's/^.*://' | sed 's/[[:space:]]*#.*$//')
   [ -z "$appVersion" ] && echo could not determine app version 1>&2 && exit 1
   echo $appVersion
fi
