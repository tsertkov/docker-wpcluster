ifeq ($(ENV),production)
	MACHINE = do-docker
	ROOT_DIR = /root
	VAR_DIR = /root/docker-data
else
	MACHINE = default
	ROOT_DIR = $(shell pwd)
	VAR_DIR = $(ROOT_DIR)/var
endif

PORT = 80
PROJECT_NAME = wpcluster
DOCKER_ENV = $(shell docker-machine env $(MACHINE) | sed -e s/export\ // -e /\^\#/d | xargs)
DOCKER_COMPOSE = VAR_DIR=$(VAR_DIR) ROOT_DIR=$(ROOT_DIR) PORT=$(PORT) $(DOCKER_ENV) \
	docker-compose -f "$(VAR_DIR)/docker-compose.yml" -p $(PROJECT_NAME)

all:
	@echo "Usage: make up|ps|stop|down"

_config:
	@echo "Generating configs..."
	@bin/build-configs.sh

up: _config
	@echo "Starting services..."
	@$(DOCKER_COMPOSE) up -d

stop:
	@echo "Stopping services..."
	@$(DDOCKER_COMPOSE) stop

down:
	@echo "Removing services..."
	@$(DOCKER_COMPOSE) down --volumes

ps:
	@$(DOCKER_COMPOSE) ps
