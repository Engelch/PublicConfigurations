#!/bin/bash
# tag docker-images
# author: engel-ch@outlook.com

function soMessage() {
# always show such a message.  If known terminal, print the message
# in reverse video mode. This is the other way, not using escape sequences

    if [ "$TERM" = xterm -o "$TERM" = vt100 -o "$TERM" = xterm-256color  -o "$TERM" = screen ] ; then
        tput smso
        /bin/echo $* 1>&2
        tput rmso
    else
        /bin/echo $* 1>&2
    fi
}

function error() {
    soMessage 'ERROR:'$*
}

function errorExit() {
    if [[ $# -lt 2 ]] ; then
        error wrong call to to errorExit.
        exit 222
    fi
    EXITCODE=$1 ; shift
    error $* 1>&2
    exit $EXITCODE
}

function err() { echo $* 1>&2; }
function err4() { echo '    '$* 1>&2; }

function usage() {
   err USAGE:
   err4 $(basename $0) docker-registry
   err4 $(basename $0) # if the docker-registry is specified in $_dockerRegistryFile
}

#################################
_dockerRegistryFile=.docker-registry

if [ -f $_dockerRegistryFile ] ; then
    _registry=$(cat $_dockerRegistryFile | grep -v ^$ | grep -v '^#' | head -n1)
    echo Auto docker registry: $_registry
else
    [ -z $1 ] && usage && exit 1
    _registry=$1
    echo Docker registry is: $_registry
fi

name=$(basename $PWD | tr [A-Z] [a-z])
echo Tagging image $name...
exit 0
_imageName=$name
_date=$(date +%y%m%d)
_sha=$(docker inspect --format='{{.Id}}' $_imageName)
_sha=$(echo $_sha | sed 's/:/_/g')

#echo SHA checksum is $_sha
echo EXECUTING THE COMMANDS...

echo docker tag $_imageName $_registry/$_imageName:latest
docker tag $_imageName $_registry/$_imageName:latest

echo docker tag $_imageName $_registry/$_imageName:$_date
docker tag $_imageName $_registry/$_imageName:$_date

echo docker tag $_imageName $_registry/$_imageName:$_date-$_sha
docker tag $_imageName $_registry/$_imageName:$_date-$_sha

# push the 3 tagged versions
echo docker push $_registry/$_imageName:latest
docker push $_registry/$_imageName:latest

echo docker push $_registry/$_imageName:$_date
docker push $_registry/$_imageName:$_date

echo docker push $_registry/$_imageName:$_date-$_sha
docker push $_registry/$_imageName:$_date-$_sha

# EOF
