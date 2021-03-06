ROOT_DIR = $(shell pwd)
CONFIG = $(ROOT_DIR)/bin/config.sh
VAR_DIR = $(shell "$(CONFIG)" VAR_DIR)
PROJECT_NAME = $(shell "$(CONFIG)" PROJECT_NAME)
ENV = $(shell "$(CONFIG)" ENV)
ifeq ($(ENV),)
	ENV = development
endif

DOCKER_COMPOSE = \
	$(shell "$(CONFIG)") \
	ENV='$(ENV)' \
	DEFAULT_HOST='$(shell "$(CONFIG)" DEFAULT_HOST)' \
	docker-compose -f '$(VAR_DIR)/docker-compose.yml' -p '$(PROJECT_NAME)'

all:
	@echo "Usage: make up|ps|stop|down|db-backup"

_config:
	@echo "Generating configs..."
	@"$(ROOT_DIR)/bin/build-configs.sh"

up: _config
	@echo "Starting services..."
	@$(DOCKER_COMPOSE) up -d || $(MAKE) down

stop:
	@echo "Stopping services..."
	@$(DOCKER_COMPOSE) stop

down:
	@echo "Removing services..."
	@$(DOCKER_COMPOSE) down --volumes

ps:
	@$(DOCKER_COMPOSE) ps

db-backup:
	@$(DOCKER_COMPOSE) start db-backup
