#! /usr/bin/make 


.PHONY: help
help:  ## Print the help documentation
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: build
build: ## Build docker images locally and don't send to dockerhub
	docker builder prune -f
	docker-compose down
	docker rmi -f robdmc/local_metabase
	docker build -t  robdmc/local_metabase .


.PHONY: shell
shell: ## Open a shell in the container
	docker-compose run --rm shell

.PHONY: create_db
create_db: ## Creates the working dataqbase
	docker-compose run --rm make_db

.PHONY: metabase
metabase: ## Start metabase server
	docker compose run --service-ports --rm  metabase

.PHONY: metabase_daemon
metabase_daemon: ## Start metabase server as a daemon
	docker compose up -d metabase

.PHONY: down
down: ## stop all docker-compose services
	docker-compose down

.PHONY: bootstrap
bootstrap: ## Delete all project resources and rebuild them
	# stop serverses and blow away all docker resources
	docker-compose down
	-docker volume rm local_metabase_db-data
	-docker volume rm local_metabase_env
	-docker images | grep 'local_metabase' | awk '{print $3}'  | xargs docker rmi
	-docker builder prune -f
	#
	# Build the docker container
	docker rmi -f robdmc/local_metabase
	docker build -t  robdmc/local_metabase .
	#
	# Create the working database
	docker-compose run --rm make_db

.PHONY: nuke
nuke: ## Nuke all resources
	# stop serverses and blow away all docker resources
	docker-compose down
	-docker volume rm local_metabase_db-data
	-docker volume rm local_metabase_env
	-docker images | grep 'metabase' | awk '{print $3}'  | xargs docker rmi
	-docker images | grep 'socat' | awk '{print $3}'  | xargs docker rmi
	-docker builder prune -f
