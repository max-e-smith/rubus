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

# copy resources into the project
mkdir "$CONFIG_DIR"
mkdir "$LOG_DIR"
cp resources/config.yaml "$PROJECT_NAME"
cp resources/.gitignore "$PROJECT_NAME"
cp resources/properties.py "$CONFIG_DIR"
cp resources/app_log.py "$LOG_DIR"
cp resources/logger_builder.py "$LOG_DIR"

# overwrite generated __init__.py to be empty (no main function)
cat <<EOF > "$MODULE_DIR/__init__.py"
EOF

# create a new main script with main function at the package root
cat <<EOF > "$MODULE_DIR/main.py"
def main():
  print("Use me as your package entrypoint")
EOF

# create a new zipapp generation script using module name
cat <<EOF > "$PROJECT_NAME/create_zipapp.sh"
shiv -c $PROJECT_NAME -o $PROJECT_NAME.pyz .

EOF

chmod 755 "$PROJECT_NAME/create_zipapp.sh"

# Update the console script configuration to use main script in module
OLD="$PROJECT_NAME:main"
NEW="$PROJECT_NAME.main:main"
sed "s/$OLD/$NEW/g" "$PROJECT_NAME/pyproject.toml"

exit $STATUS