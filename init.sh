#!/bin/bash

set -ex

STATUS=0

INIT_SCRIPT=$0                           # init script will be deleted ultimately
PROJECT_ROOT=$(dirname "$0")             # script dirname may be different than pwd
cd "$PROJECT_ROOT"                       # ensure pwd is the same as init script
PROJECT_NAME=${PWD##*/}                  # project name is the same as parent directory

# execute project creation script in the same directory as script
PROJECT_GEN_DIR="$PROJECT_ROOT/project-generation"
cd "$PROJECT_GEN_DIR"
./create_project.sh  "$PROJECT_NAME"

# move generated files to the project root, overwriting readme, .gitignore and any others
cd "$PROJECT_ROOT"
cp -rf "$PROJECT_GEN_DIR"/generated/"$PROJECT_NAME"/* .

# cleanup the project generation resources and scripts
rm -rf "$PROJECT_GEN_DIR"
rm "$INIT_SCRIPT"

exit "$STATUS"