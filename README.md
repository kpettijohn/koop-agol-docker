# koop-agol-docker

**Work In Progress**

## Getting started

Grab [docker](https://www.docker.com/toolbox), [docker-machine](https://docs.docker.com/machine/install-machine/), and [docker-compose](https://docs.docker.com/machine/install-machine/).

The quickest way to get started is to install the [Docker Toolbox](https://www.docker.com/toolbox).

Once you have docker setup you can run the following script to create a Koop server, Koop export worker, Koop agol worker, postgis, and redis containers.

```
./config/scripts/koop.sh recreate
```

Each time you run `./koop.sh recreate` docker-compose will do the following:

* Stop and force remove any existing containers
* Build the Koop image from the repositories Dockerfile
* Start redis and postgis containers 
* Create the Koop database for postgis and start Koop server
* Start the Koop agol and export workers
* Run `docker-compose logs`

## Configuration

Configuration is handled by [node-config](https://github.com/lorenwest/node-config) which reads the default settings from `config/default.yaml`. Individual values can be overridden using environment variables configured in `config/custom-environment-variables.json`. You can set environment variables for each container within the `docker-compose.yml` file.

## Tests

Tests are using [Mocha](https://github.com/mochajs/mocha) and [Nock](https://github.com/pgte/nock). 

Currently all tests make real HTTP calls to a provided Koop host. Each test will record the HTTP call and save it as a fixture in `test/fixtures`. All following test runs will use the local fixtures. You can force a fresh set of fixtures by passing `NOCK_RECORD=1` when executing tests.

Set the host ip/hostname for Koop
```
TEST_KOOP_HOST=`docker-machine ip dev` npm test
```

Force a refresh of test fixtures
```
NOCK_RECORD=1 TEST_KOOP_HOST=`docker-machine ip dev` npm test
```

Generate JUnit test report
```
JUNIT_REPORT_PATH=report.xml JUNIT_REPORT_STACK=1 ./node_modules/mocha/bin/mocha --reporter mocha-jenkins-reporter
```

## Contributing

Esri welcomes contributions from anyone and everyone. Please see our [guidelines for contributing](https://github.com/Esri/contributing).

## License

[Apache-2.0](LICENSE.md)
