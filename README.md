# Dockerfiles for running ui-tests in robotframework

Inspired by https://github.com/danielwhatmuff/robot-docker

This Dockerfile is designed to make it easier to run robot framework based UI-tests on CI environments.

It includes the ability to run tests sequentially with pybot or parallel with pabot

User needs to mount tests from host to docker image and set required environment variables.

## Usage

Project includes two simple tests in tests directory, which also show how chromedriver can be configured to be used with SeleniumLibrary.

Run tests with pybot, passing only mandatory environment variables ROBOT_TESTS and ROBOT_LOGS

``
docker run --rm -e ROBOT_TESTS=/tests/ -e ROBOT_LOGS=/tests/logs/ -v $(pwd)/tests:/tests/ -ti yleisradio/docker-robotframework
``

Use tags to select only certain tests

``
docker run --rm -e ROBOT_TESTS=/tests/ -e ROBOT_LOGS=/tests/logs/ -e ROBOT_ITAG=google -v $(pwd)/tests:/tests/ -ti yleisradio/docker-robotframework
``

Run tests with pabot (2 processes without locks and 15 processes with locks):

``
docker run --rm -e ROBOT_MODE=pabot -e ROBOT_TESTS=/tests/ -e ROBOT_LOGS=/tests/logs/ -e LOG_LEVEL=DEBUG -v $(pwd)/tests:/tests/ -ti yleisradio/docker-robotframework
``

``
docker run --rm -e ROBOT_MODE=pabot -e PABOT_LIB=pabotlib -e PABOT_RES=/tests/conf/list_for_pabot.dat -e ROBOT_TESTS=/tests/tests -e ROBOT_LOGS=/tests/logs/ -e PABOT_PROC=15 --shm-size 6g -v $(pwd):/tests -ti yleisradio/docker-robotframework
``

Mandatory environment variables:

- ROBOT_TESTS = directory inside the container where tests are mounted / bound to
- ROBOT_LOGS = directory inside the container where logs will be written to

Optional environment variables:

- ROBOT_MODE= pabot runs tests in parallel mode with pabot
- PABOT_LIB= indicates that pabot library is used
- PABOT_RES= resource file which contain value sets needed with locks
- PABOT_PROC= number of processes pabot should use
- ROBOT_VAR = variablefile used when running the test(s). ( passed as --variablefile to pybot/pabot )
- ROBOT_ITAG = tags to be included in the test run ( passed as -i to pybot )
- ROBOT_ETAG = tags to be excluded from the test run ( passed as -e to pybot )
- ROBOT_TEST = test to be run ( passed as -t to pybot )
- ROBOT_SUITE = suite to be run ( passed as -s to pybot )
- RES = resolution used in Xvfb when using browser tests

Note that PABOT_LIB and PABOT_RES must be right after the ROBOT_MODE (otherwise the value set file is not found)

### Build image locally 

If you do changes to the image, you can test local version by building your own image:

```
cd robotframework
docker build -t docker-robotframework .
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yleisradio/docker-robotframework. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The Dockerfile is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
