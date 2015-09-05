# koop-agol-docker

**Work In Progress**

## Getting started

Grab [docker](https://www.docker.com/toolbox), [docker-machine](https://docs.docker.com/machine/install-machine/), and [docker-compose](https://docs.docker.com/machine/install-machine/).

The quickest way to get started is to install the [Docker Toolbox](https://www.docker.com/toolbox).

Once you have docker setup you can run the following script to create a Koop server, Koop export worker, Koop agol worker, postgis, and redis containers.

```
./config/scripts/koop.sh re-create
```

Each time you run `./koop.sh re-create` docker-compose will do the following:

* Stop and force remove any existing containers
* Build the Koop image from the repositories Dockerfile
* Start redis and postgis containers 
* Create the Koop database for postgis and start Koop server
* Start the Koop agol and export workers
* Run `docker-compose logs`

## Configuration

Configuration is handled by [node-config](https://github.com/lorenwest/node-config) which reads the default settings from `config/default.yaml`. Individual values can be overridden using environment variables configured in `config/custom-environment-variables.json`. You can set environment variables for each container within the `docker-compose.yml` file.

## Contributing

Esri welcomes contributions from anyone and everyone. Please see our [guidelines for contributing](https://github.com/Esri/contributing).

## License

[Apache-2.0](LICENSE.md)
