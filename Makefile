ifeq ($(ENV),production)
	MACHINE = do-docker
	DATA_DIR = /root/docker-data
else
	MACHINE = default
	DATA_DIR = $(shell pwd)/var
endif

PORT = 80
PROJECT_NAME = wpcluster
DOCKER_ENV = $(shell docker-machine env $(MACHINE) | sed -e s/export\ // -e /\^\#/d | xargs)
DOCKER_COMPOSE = DATA_DIR=$(DATA_DIR) PORT=$(PORT) $(DOCKER_ENV) \
	docker-compose -f "$(DATA_DIR)/docker-compose.yml" -p $(PROJECT_NAME)

all:
	@echo "Usage: make up|status|stop|down|config"

config:
	@echo "Generating configs..."
	@bin/build-configs.sh

up:
	@echo "Starting services..."
	@$(DOCKER_COMPOSE) up -d

stop:
	@echo "Stopping services..."
	@$(DDOCKER_COMPOSE) stop

down:
	@echo "Removing services..."
	@$(DOCKER_COMPOSE) down --volumes

status:
	@$(DOCKER_COMPOSE) ps
