#!/bin/bash

VERSION=0.2.1

# dry-run 
[ "$1" = -n ] && dry=echo && echo DRY RUN ONLY........................

for file in _container_* ; do
  [ $file = '_container_*'  ] && continue
  container=$(echo $file | sed -e "s/_container_//" | sed -e "s,_,/,g" ) 
done
if [ -z $container ] ; then
  container=$(basename $PWD | sed -e 's/ /_/g' | tr [A-Z] [a-z]) # as in dockerBuild
fi

if [ -r .version ] ; then
    version=":"$(cat .version | grep -v '^$' | sed 's/[[:space:]]*#.*$//')
    echo version is $version
    ver="-t $container$version"
fi
echo Building image "[$VERSION]" $ver $container $container:latest...
$dry docker build $ver -t $container -t $container:latest .

# EOF
