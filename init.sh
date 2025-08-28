#!/bin/bash

set -ex

STATUS=0

PROJECT_NAME=${PWD##*/}
INIT_SCRIPT="$PWD/init.sh"
PROJECT_GEN_DIR="$PWD/project-generation"

bash "$PROJECT_GEN_DIR/create_project.sh $PROJECT_NAME"

cp -rf "$PROJECT_GEN_DIR"/generated/"$PROJECT_NAME"/* .

# Cleanup
rm -rf "$PROJECT_GEN_DIR"
rm "$INIT_SCRIPT"

exit "$STATUS"