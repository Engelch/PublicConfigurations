#!/usr/bin/env bash

VERSION=0.1.0

function err()          { echo $* 1>&2; } # just write to stderr

function debugSet()             { DebugFlag=TRUE; return 0; }
function debugUnset()           { DebugFlag=; return 0; }
function debugExecIfDebug()     { [ ! -z $DebugFlag ] && $*; }
function debug()                { [ ! -z $DebugFlag ] && err 'DEBUG:' $* 1>&2 ; return 0; }


[ "$1" = -d ] && shift && debugSet
if [ "$1" = -n ]  ; then # dry-run
 echo DRY RUN MODE ....................
 dry="echo # "
 shift
fi
[ "$1" = -d ] && shift && debugSet # can be first or second opt
debug is ON ......................

for file in p*:* p*_* ; do
  [ $file = 'p*:*' -o $file = 'p*_*' ] && continue
  map="-p$(echo $file | sed -e 's/_/:/'  -e 's/^p//') $map"
done

debug Port mapping: $map

for file in net*  ; do
  [ $file = 'net_*'  ] && continue
  net="--net $(echo $file | sed -e 's/^net_//' ) $net"
done

debug Nets are  $net

[ -f rm ] && rm='--rm'

debug Remove container is $rm

for file in name_* ; do
  [ $file = 'name_*'  ] && continue
  name="--name $(echo $file | sed -e 's/^name_//' ) $name"
done

debug Container name is $name


for file in -v* ; do
  [ $file = '-v*'  ] && continue
  inmap=$(echo $file | sed 's/^-v//' | sed -e "s,.:,$(pwd):," | sed -e "s,_,/,g" ) 
  dirmap="-v $inmap  $dirmap"
done

debug Directory mappings are $dirmap

for file in container-* ; do
  [ $file = 'container-*'  ] && continue
  container=$(echo $file | sed -e "s/container-//" | sed -e "s,_,/,g" ) 
done

debug Container is $container

[ -f sudo ] && sudo=sudo 
debug sudo is set to $sudo

if [ "$1" = -k ] ; then
  debug docker kill $name
  $dry docker kill $name
  res=$?
else
  debug $sudo docker run $rm  $net $name $map $dirmap $container 
  $dry $sudo docker run $rm  $net $name $map $dirmap $container
  res=$?
fi

exit $res

# eof
