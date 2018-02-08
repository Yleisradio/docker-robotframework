# Dockerfiles for running ui-tests in robotframework

Inspired by https://github.com/danielwhatmuff/robot-docker

- pybot version

- pabot version

## Usage

TODO

### Build image locally 

```
cd robotframework
docker build -t yledockertest .
```

``
docker run --rm -e ROBOT_TESTS=/tests/ -v $(pwd)/tests:/tests/ -ti yledockertest
``

``
docker run --rm -e ROBOT_MODE=pabot -e ROBOT_TESTS=/tests/ -v $(pwd)/tests:/tests/ -ti yledockertest
``


use prebuilt image

pass environment variables controlling test execution
 
- test location
- tags to run



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yleisradio/docker-robotframework. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The Dockerfile is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
