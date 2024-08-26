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

.PHONY: data_link_instructions
data_link_instructions: ## Print instructions on how to link data files to the container
	@echo ""
	@echo "You should probably just copy your data files to the  ./data directory"
	@echo "But if you don't want to, you can create recursive hard-links with the command:"
	@echo ""
	@echo "cp -lR /path/to/your/data/on/host ./data"
	@echo ""

.PHONY: shell
shell: ## Open a shell in the container
	docker-compose run --rm shell

.PHONY: create_db
create_db: ## Creates the working dataqbase
	docker-compose run --rm make_db

.PHONY: metabase
metabase: ## Start metabase server
	docker compose run --service-ports --rm  metabase

.PHONY: backup
backup: ## Backup the metabase database
	docker compose run --rm  backup

.PHONY: restore
restore: ## Restore the metabase database
	docker compose run --rm  restore

.PHONY: metabase_daemon
metabase_daemon: ## Start metabase server as a daemon
	docker compose up -d metabase

.PHONY: down
down: ## stop all docker-compose services
	docker-compose down

# .PHONY: download_duckdb_driver
# download_duckdb_driver: ## Download the duckdb driver
# 	mkdir -p ./metabase_duckdb_driver
# 	# You may need to check for updated drivers at https://github.com/MotherDuck-Open-Source/metabase_duckdb_driver
# 	wget -P ./metabase_duckdb_driver https://github.com/MotherDuck-Open-Source/metabase_duckdb_driver/releases/download/0.2.9/duckdb.metabase-driver.jar

.PHONY: bootstrap
bootstrap: ## Delete all project resources and rebuild them
	# stop serverses and blow away all docker resources
	docker-compose down
	-docker volume rm local_metabase_db-data
	-docker volume rm local_metabase_env
	-docker images | grep 'local_metabase' | awk '{print $3}'  | xargs docker rmi
	-docker builder prune -f
	-rm ./metabase_duckdb_driver/*
	# Download the duckdb driver
	mkdir -p ./metabase_duckdb_driver
	# wget -P ./metabase_duckdb_driver https://github.com/MotherDuck-Open-Source/metabase_duckdb_driver/releases/download/0.2.9/duckdb.metabase-driver.jar

	# Build the docker container
	docker rmi -f robdmc/local_metabase
	docker build -t  robdmc/local_metabase .
	docker build -t  robdmc/metabase ./metabase_docker
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
