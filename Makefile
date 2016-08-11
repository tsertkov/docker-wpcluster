PROJECT_NAME = wpcluster
ENV ?= development
ROOT_DIR = $(shell pwd)
VAR_DIR = $(ROOT_DIR)/var
DOCKER_COMPOSE = \
	ENV=$(ENV) \
	VAR_DIR=$(VAR_DIR) \
	ROOT_DIR=$(ROOT_DIR) \
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
	@$(DOCKER_COMPOSE) stop

down:
	@echo "Removing services..."
	@$(DOCKER_COMPOSE) down --volumes

ps:
	@$(DOCKER_COMPOSE) ps
