#!/bin/bash
name=$(basename $PWD | sed -e 's/ /_/g' | tr [A-Z] [a-z])
echo Building image $name...
docker build -t $name .
