#!/usr/bin/env bash

VERSION=0.2.7

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
debug debug is ON ......................
debug version is $VERSION

for file in _p*:* _p*_* ; do
  [ $file = '_p*:*' -o $file = '_p*_*' ] && continue
  map="-p$(echo $file | sed -e 's/^_p//' | sed -e 's/_/:/') $map"
done

debug Port mapping: $map

for file in _net_*  ; do
  [ $file = '_net_*'  ] && continue
  net="--net $(echo $file | sed -e 's/^_net_//' ) $net"
done

debug Nets are $net

[ -f --rm -o -f __rm -o -f _rm ] && rm='--rm'

debug Remove container is $rm

for file in _name_* ; do
  [ $file = '_name_*'  ] && continue
  name="--name $(echo $file | sed -e 's/^_name_//' ) $name"
done

debug Container name is $name


for file in _v* ; do
  [ $file = '_v*'  ] && continue
  srcmap=$(echo $file | sed 's/^_v//' | sed -e "s,:.*,," | sed "s,_,/,g" | sed -e s",^\.,$(pwd)," )
  dstmap=$(echo $file | sed 's/^_v//' | sed -e "s,.*:,," | sed "s,_,/,g" ) 
  debug srcmap $srcmap dstmap $dstmap
  dirmap="-v $srcmap:$dstmap $dirmap"
done

debug Directory mappings are $dirmap

for file in _container_* ; do
  [ $file = '_container_*'  ] && continue
  container=$(echo $file | sed -e "s/_container_//" | sed -e "s,_,/,g" ) 
done
if [ -z $container ] ; then
  container=$(basename $PWD | sed -e 's/ /_/g' | tr [A-Z] [a-z]) # as in dockerBuild
fi

debug Container is $container

[ -f _sudo ] && sudo=sudo 
debug sudo is set to $sudo

if [ "$1" = -k ] ; then
  if [ ! -z $name ] ; then
    container=$(echo $name | awk '{ print $2 }' )
    debug docker kill $container
    $dry docker kill $container
    res=$?
  else  
    err ERROR No clear container name.
    res=1
  fi
else
  debug $sudo docker run $rm  $net $name $map $dirmap $* $container 
  $dry $sudo docker run $rm  $net $name $map $dirmap $* $container
  res=$?
fi

exit $res

# eof
