# Wordpress containerised cluster

## Requirements

- [docker-compose](https://docs.docker.com/compose/install/) >= 1.8

## Usage

```bash
# dev mode is default unless ENV var is set
$ make
Usage: make up|ps|stop|down

# launch in production mode
$ ENV=production make up
```
