# rubus
Super opinionated, basic python project setup for quickly getting a new project up that needs
to be deployed as a zipapp, is baseline configurable, and has some logging up and running.

## System requirements

Requires uv to create the project.
http://docs.astral.sh/uv/

The generated project itself also requires shiv to package app into a zipapp
https://shiv.readthedocs.io/en/latest/

## Usage
Can be used as a template repository using the init.sh script OR used to repeatedly generate a basic 
project structure that can be copied for use elsewhere. 

### Template Repository Usage
Use github feature (UI or CLI) to create a new repo from the original rubus repository. 

Run the init.sh script at the root of the project in your newly created repo. 

Commit the changes!

### Basic Project Structure Generation Usage
Run the `create_project.sh` from within the project-generation subfolder with a project name as the only parameter 
in order to generate a project structure that can be copied for use elsewhere. 

The generated project can be deleted using the `delete_project.sh` script, passing the project name as only parameter.

Copy the generated project structure to another directory in order to use and commit it as a separate project.
