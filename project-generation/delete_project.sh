#!/bin/bash

set -ex

STATUS=0

if [ -n "$1" ];
  then
    PROJECT_NAME="$1"
  else
    exit 1
fi

mkdir -p generated
cd generated

if [ ! -d "$PWD/$PROJECT_NAME" ];
  then
    echo "Error: '$PROJECT_NAME' is not a valid directory name in the current path."
    exit 1
fi

rm -rf "./$PROJECT_NAME"

exit $STATUS