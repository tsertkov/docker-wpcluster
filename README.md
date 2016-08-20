# Wordpress containerised cluster

## Requirements

- [docker](https://docs.docker.com/engine/installation/) >= 1.12
- [docker-compose](https://docs.docker.com/compose/install/) >= 1.8

## Usage

```bash
$ git clone https://github.com/tsertkov/docker-wpcluster.git
$ cd docker-wpcluster
$ cp config.env.dist config.env
$ make up
Usage: make up|ps|stop|down
```