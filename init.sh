#!/bin/bash

set -ex

STATUS=0

PROJECT_NAME=${PWD##*/}
INIT_SCRIPT="$PWD/init.sh"
PROJECT_ROOT="$PWD"
PROJECT_GEN_DIR="$PWD/project-generation"

echo "cd to: $PROJECT_GEN_DIR"

cd "$PROJECT_GEN_DIR"
bash "create_project.sh $PROJECT_NAME"

echo "cd back to $PROJECT_ROOT"
cd "$PROJECT_ROOT"

cp -rf "$PROJECT_GEN_DIR"/generated/"$PROJECT_NAME"/* .

# Cleanup
rm -rf "$PROJECT_GEN_DIR"
rm "$INIT_SCRIPT"

exit "$STATUS"