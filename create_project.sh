#!/bin/bash

set -ex

STATUS=0

if [ -n "$1" ]; then
    PROJECT_NAME="$1"

    else
      exit 1
fi

# initialize package type project structure with uv
uv init "$PROJECT_NAME" --build-backend uv

MODULE_DIR="$PROJECT_NAME/src/$PROJECT_NAME"
CONFIG_DIR="$MODULE_DIR/config"
LOG_DIR="$MODULE_DIR/logging"

mkdir "$CONFIG_DIR"
mkdir "$LOG_DIR"

# overwrite generated __init__.py with main function
cat <<EOF > "$MODULE_DIR/__init__.py"
EOF

# create a new main script at the module root
cat <<EOF > "$MODULE_DIR/main.py"
def main():
  print("Use me as your package entrypoint")
EOF

# Update the console script configuration to use main script in module
OLD="$PROJECT_NAME:main"
NEW="$PROJECT_NAME.main:main"
sed "s/$OLD/$NEW/g" "$PROJECT_NAME/pyproject.toml"

# copy resources into the project
cp resources/config.yaml "$PROJECT_NAME"
cp resources/.gitignore "$PROJECT_NAME"
cp resources/properties.py "$CONFIG_DIR"
cp resources/app_log.py "$LOG_DIR"
cp resources/logger_builder.py "$LOG_DIR"

exit $STATUS