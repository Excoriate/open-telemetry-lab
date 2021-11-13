.SHELL := /usr/bin/bash

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Global variables
CURRENT_FOLDER=$(shell basename "$$(pwd)")

# Make file specific arguments
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

# Configuration
MICROSERVICE1="microservice-1/"
MICROSERVICE2="microservice-2/"
MICROSERVICE3="microservice-3/"
WORKING_DIR="nodejs"

CHDIR_SHELL := $(SHELL)

# Utility to jump into different directories
define jump
   $(eval _D=$(firstword $(1) $(@D)))
   $(info $(MAKE): cd $(_D)) $(eval SHELL = cd $(_D); $(CHDIR_SHELL))
endef

# Setup service
define setup_service
	@echo "$(YELLOW)$(BOLD)Setting up microservice...$(RESET)"
	@echo "Acting on folder: `pwd`"
	@npm install
	@ls -ltrah
	@echo "$(GREEN)$(BOLD)Installation complete...$(RESET)"
endef

# Clean node_modules
define clean_services_node_modules
	@echo "$(YELLOW)$(BOLD)Cleaning up node_modules in a service...$(RESET)"
	@echo "Acting on folder: `pwd`"
	@rm -rf node_modules
	@rm -rf dist
	@ls -ltrah
	@echo "$(GREEN)$(BOLD)All node_modules dependencies were removed.$(RESET)"
endef

container_build: # Build all the container images using docker-compose build
	@echo "$(YELLOW)$(BOLD)Creating container images...$(RESET)"
	docker compose build
	@echo "$(GREEN)$(BOLD)Container images created successfully$(RESET)"

container_up: # Run all the containers, in detached mode
	@echo "$(YELLOW)$(BOLD)Starting containers...$(RESET)"

	docker compose up -d
	docker ps -a

	@echo "$(YELLOW)$(BOLD)Containers setup completed$(RESET)"

install_s1:
	@echo "$(BOLD)Installing dependencies in all microservices (service 1)...$(RESET)"

	$(call jump, $(MICROSERVICE1))
	$(call setup_service)

	@echo "$(GREEN)$(BOLD)Services were installed successfully$(RESET)"

install_s2:
	@echo "$(BOLD)Installing dependencies in all microservices (service 2)...$(RESET)"

	$(call jump, $(MICROSERVICE2))
	$(call setup_service)

	@echo "$(GREEN)$(BOLD)Services were installed successfully$(RESET)"

install_s3:
	@echo "$(BOLD)Installing dependencies in all microservices (service 3)...$(RESET)"

	$(call jump, $(MICROSERVICE3))
	$(call setup_service)

	@echo "$(GREEN)$(BOLD)Services were installed successfully$(RESET)"

clean_s1:
	@echo "$(BOLD)Cleaning (service 1)...$(RESET)"

	$(call jump, $(MICROSERVICE1))
	$(call clean_services_node_modules)

	@echo "$(GREEN)$(BOLD)Done$(RESET)"

clean_s2:
	@echo "$(BOLD)Cleaning (service 2)...$(RESET)"

	$(call jump, $(MICROSERVICE2))
	$(call clean_services_node_modules)

	@echo "$(GREEN)$(BOLD)Done$(RESET)"

clean_s3:
	@echo "$(BOLD)Cleaning (service 3)...$(RESET)"

	$(call jump, $(MICROSERVICE3))
	$(call clean_services_node_modules)

	@echo "$(GREEN)$(BOLD)Done$(RESET)"


# Entry points
install: install_s1 install_s2 install_s3 ## Install all the dependencies across all the microservices
reset: clean_s1 clean_s2 clean_s3 ## Clean the /dist folder and the node_modules/ folder in all the microservices
containers: container_build container_up ## Build all container images, and start containers in detached mode
