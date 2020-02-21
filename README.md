# Dockerfiles for running ui-tests in robotframework

This Dockerfile is designed to make it easier to build up python 3.8 environment for robot framework based UI-tests.

It includes the ability to run tests sequentially with pybot or parallel with pabot

User needs to mount tests from host to docker image. It may be useful to set some alias to mac if needed to run tests with pabot and robot, e.g.
- 

## Pre-requisites  
Clone yle-ovp-test repository before creating image.  
Python virtual environment for version 3.8 is needed for yle-ovp-test (here some instructions: https://github.com/Yleisradio/yle-ovp-test/wiki/Running-tests-on-Mac-OS).  
AWS credentials are needed to run tests (https://github.com/Yleisradio/wiki/wiki/01-Credentials).

## Usage
Dockerfile and requirements.txt contain all that is needed to run robot framework tests from yle-ovp-test.
build.sh automates the building of image and container. There is needed 4 arguments:
- folder name - which ubuntu and python version is used (default is ubuntu1804)
- container name - how the container is named (default is rf-chrome)
- image name - how the image is named (default is docker-robotframework/python3.8)
- mount name - where yle-ovp-test is mounted in container (default is /ovp_tests)

Create image and container:  
  
``  cd python3.8  ``  
``  ./build.sh  ``  

Run example test in container:
  
``  docker start rf-chrome  ``  
``  docker attach rf-chrome  ``  
``  cd /ovp_tests  ``  
``  ./run_tests travis  ``  
``  exit  ``

Tip: ./run_tests xxx lists all tests that can be run with this script

More scripts for running tests are found here: https://github.com/Yleisradio/yle-ovp-test/tree/master/scripts/robot