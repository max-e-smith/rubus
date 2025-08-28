#!/bin/bash

set -ex

STATUS=0

if [ -n "$1" ]; then
    PROJECT_NAME="$1"

    else
      exit 1
fi

mkdir -p generated
cd generated

MODULE_DIR="$PWD/$PROJECT_NAME/src/$PROJECT_NAME"
CONFIG_DIR="$PWD/$MODULE_DIR/config"
LOG_DIR="$PWD/$MODULE_DIR/logging"

# initialize package type project structure with uv
uv init "$PROJECT_NAME" --build-backend uv

if [ -z "$MODULE_DIR" ]; then
  echo "Directory '$MODULE_DIR' was not created."
  exit 1
fi

# Update the console script configuration to use main script in module
OLD="$PROJECT_NAME:main"
NEW="$PROJECT_NAME.main:main"
sed "s/$OLD/$NEW/g" "$PROJECT_NAME/pyproject.toml"

# copy resources into the project
mkdir "$CONFIG_DIR"
mkdir "$LOG_DIR"
cp ../resources/config.yaml "$PROJECT_NAME"
cp ../resources/.gitignore "$PROJECT_NAME"
cp ../resources/properties.py "$CONFIG_DIR"
cp ../resources/app_log.py "$LOG_DIR"
cp ../resources/logger_builder.py "$LOG_DIR"

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


# create a basic README with project name
cat <<EOF > "$PROJECT_NAME/README.md"
# $PROJECT_NAME

## Requirements
uv (builds project) -- https://docs.astral.sh/uv/
shiv (packages project into python zipapp executable) -- https://shiv.readthedocs.io/en/latest/

## Usage
App Usage Goes Here

## Development
### Package mgmt
packages can be added to the project using uv, something like \`uv add <dependency>\`. Refer to uv's
documentation for all features and syntax available.

### Zip App
When writing your project code, keep these two things in mind:
 - The main() function in main.py is by default the console script (entry point) for the package. The
pyproject.toml should be updated if this is changed.
- All modules imports in the package should begin by importing from the base module $PROJECT_NAME

When ready for the project to get packaged into a zipapp \"executable\", use the create_zipapp.sh script to
generate a $PROJECT_NAME.pyz file that can be distributed to the deployment destination where
a compatible version python interpreter exists.

EOF

exit $STATUS