#!/usr/bin/env bash

function err()          { echo $* 1>&2; } # just write to stderr

# -d as debug option to show if the correct line is identified
# without -d, the line is reduced to the pure version number.

declare -r _version="0.2.0"

if [ "$1" = -h -o "$1" = --help ] ; then
   echo $(basename $0)'     ' show and determines the app version  1>&2
   echo '                that is used by applications such as' 1>&2
   echo '                bumppatch, bumpminor, and bumpmajor' 1>&2
   echo '                to update it accordingly'  1>&2
   echo OPTIONS 1>&2
   echo ' -d             Debug, show full line matched,' 1>&2
   echo '                not just the version string' 1>&2
   exit 1
fi

appDir=$(dirname $0)
cd "$appDir"
[ $(pwd | xargs basename) = bin ] && cd .. # correct location if binary in bin

if [ -f "./versionFilePattern" ] ; then
   # _versionFilePattern can either contain specific filenames to search for version information or a pattern
   _versionFilePattern=$(cat "./versionFilePattern" | grep -v '^$' | egrep -v '^[[:space:]]*#' | sed 's/[[:space:]]*#.*$//')
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
