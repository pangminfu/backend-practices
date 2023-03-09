.PHONY: help lint build

help: ## show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

PROJECT_NAME?=todo
APP_NAME?=todo-api
APP_MIG_NAME?=$(APP_NAME)-db-migration

SHELL = /bin/bash

########
# lint #
########

lint: ## lints the entire codebase
	@golangci-lint run ./... --config=./.golangci.toml

#########
# build #
#########

build: lint docker-build ## lint before building the docker image

docker-build: docker-build-api ## default docker build

docker-build-api: TAG_NAME=$(APP_NAME) ## docker build for api
docker-build-api: BINARY_NAME="api"
docker-build-api: GLOBAL_VAR_PKG="server"
docker-build-api: docker-build-generic

docker-build-mig: TAG_NAME=$(APP_MIG_NAME) ## docker build for migrate
docker-build-mig: BINARY_NAME="migrate"
docker-build-mig: GLOBAL_VAR_PKG="main"
docker-build-mig: docker-build-generic

docker-build-generic:
	if [[ -n "${PLATFORM}" ]]; then \
		PLATFORM_FLAG="--platform ${PLATFORM}"; \
	fi; \
	docker run --privileged --rm tonistiigi/binfmt --install all; \
	DOCKER_BUILDKIT=1 \
	docker buildx build \
		-f Dockerfile \
		-t $(TAG_NAME) \
		$$PLATFORM_FLAG \
		--build-arg BINARY_NAME=$(BINARY_NAME) \
		--build-arg GLOBAL_VAR_PKG=$(GLOBAL_VAR_PKG) \
		--build-arg LAST_MAIN_COMMIT_HASH=$(shell git rev-parse --short HEAD) \
		--build-arg LAST_MAIN_COMMIT_TIME=$(shell git log main -n1 --format='%cd' --date='iso-strict') \
		--ssh default \
		--progress=plain \
		--load \
		./