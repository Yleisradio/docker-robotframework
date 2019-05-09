#!/usr/bin/env bash

<< ////
*********************************************************************************************************************
pre-requisites:
 - yle-ovp-test repository cloned and updated in the same parent directory where the ovp-xxx-repository is

using the script:
 - copy this script to the repository you want to test (e.g. to the folder 'robotframework')
 - run the script from main level of the ovp-repository (e.g. ./robotframework/run-rf-tests.sh xxx yyy zzz)

variables with this sh-file:
 - 1. where feenix is run (feenix url selection and selection if image is built or not). Options:
       - travis (docker-feenix with image building in Travis --> for ovp-ui test run),
       - local-with-image (docker-feenix with image building in own laptop),
       - local-without-image (docker-feenix without image building in own laptop),
       - without-docker (Feenix in yle test environment)
       - local-without-building (docker-feenix without image buiding and without starting the container in own laptop)
       - feenix-mac (feenix at own laptop --> check the url from robotframework-tests/env/test_env.py)
 - 2. type how to select tests and correct pabot script (testtag or testsuite)
 - 3. name for type (e.g. tag 'image' or test suite 'live_order_with_encoder'

example:
 - from repository ovp-ui in yle test environment run all tests for images:
 ./robotframework/run-rf-tests.sh without-docker testtag image

test results and logs:
 - test logs are always stored to the directory 'yle-ovp-test/logs'
 - log.html is the best result file for debugging

*********************************************************************************************************************
////

#other than yle-ovp-test repo:
export OVP_REPO_FOLDER=$(pwd)
cd ..
export FOLDER=$(pwd)
export OVP_TEST_FOLDER=$FOLDER/yle-ovp-test;

echo "ovp-repo: $OVP_REPO_FOLDER"
echo "parent folder: $(pwd)"
echo "RF tests: $OVP_TEST_FOLDER"

cd $OVP_TEST_FOLDER

# Selecting the Feenix url and putting it in the new file (test_env_for_run.py) which is used in run_pabot_for_xxx.sh.
if
    [ $1 == 'without-docker' ]; then
    sed 's/{{FEENIX_SELECTION}}/FEENIX_YLE/g' env/test_env.py > env/test_env_for_run.py;

elif
    [ $1 == 'feenix-mac' ]; then
    sed 's/{{FEENIX_SELECTION}}/FEENIX_MAC/g' env/test_env.py > env/test_env_for_run.py;

else
    sed 's/{{FEENIX_SELECTION}}/FEENIX_DOCKER/g' env/test_env.py > env/test_env_for_run.py;
fi

# scripts for setting test environment up:
echo "Setting Feenix test environment up: $1"
echo

export OVP_SCRIPT_LOCATION=$OVP_REPO_FOLDER/robotframework
export TEST_SCRIPT_LOCATION=$OVP_TEST_FOLDER/scripts/pabot
echo "Script location: $OVP_SCRIPT_LOCATION"

# Correct user rights
chmod ugo+x $TEST_SCRIPT_LOCATION/*
chmod ugo+x $OVP_SCRIPT_LOCATION/*

# Building image and creating container whenever needed. After that starting Feenix.
if    [ $1 == 'without-docker' ]; then
        echo 'Starting Feenix in yle test environment'
        docker network create rftest-net

    elif
        [ $1 == 'local-without-image' ]; then
        echo 'Starting Feenix locally in container (no image building)'
        $TEST_SCRIPT_LOCATION/tests/start-feenix.sh local no-image

    elif
        [ $1 == 'travis' ]; then
        echo 'Starting Feenix in Travis'
        $TEST_SCRIPT_LOCATION/tests/start-feenix.sh travis no-image

    elif
        [ $1 == 'local-with-image' ]; then
        echo 'Starting Feenix locally in container (build image first)'
        $TEST_SCRIPT_LOCATION/tests/start-feenix.sh local build-image

    elif
        [ $1 == 'feenix-mac' ]; then
        echo "Starting Feenix locally ($FEENIX_MAC)"
        echo
        $TEST_SCRIPT_LOCATION/tests/start-feenix.sh feenix-mac
fi

# Selecting the type how to select tests, by suite or tag.
export CONFIGURATION_FILE=$OVP_TEST_FOLDER/env/test_env_app.py
python $CONFIGURATION_FILE

run_tests()
{
  TYPE=$1
  NAME=$2
  docker run --rm --network rftest-net \
       -e ROBOT_MODE=pabot \
       -e PABOT_LIB=pabotlib \
       -e ROBOT_VAR=/ovp-tests/env/test_env_for_run.py \
       -e ROBOT_TESTS=/ovp-tests/tests \
       -e ROBOT_ETAG=test-not-ready \
       -e ROBOT_$TYPE=$NAME \
       -e ROBOT_LOGS=/ovp-tests/logs/ \
       -e LOG_LEVEL=INFO \
       -e PABOT_PROC=15 \
       --shm-size 6g \
       -v $(pwd):/ovp-tests \
       -ti yleisradio/docker-robotframework

}

if 
	[ $2 == 'testtag' ]; then
        echo "running tests with tags: $3..."
	run_tests ITAG $3
    elif
        [ $2 == 'testsuite' ]; then
        echo "running test suite: $3..."
        run_tests SUITE $3
fi

exit $RESULT;

