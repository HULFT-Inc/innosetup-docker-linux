USER := $(shell whoami)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
DOCKER_TAG := $(USER)/innosetup:$(GIT_BRANCH)

.PHONY: build
build: ## Build the Docker image
build:
	docker build -t $(DOCKER_TAG) .

.PHONY: test
test: ## Test the Docker image
test:
	docker run --rm -i -v $(PWD):/work $(DOCKER_TAG) helloworld.iss

.PHONY: shell
shell: ## Open a shell in the Docker container
shell:
	docker run --rm -it -v $(PWD):/work --entrypoint /bin/bash $(DOCKER_TAG)

.PHONY: clean
clean: ## Remove generated files
clean:
	rm -rf Output

.PHONY: help
help: ## Show this help text
	$(info usage: make [target])
	$(info )
	$(info Available targets:)
	@awk -F ':.*?## *' '/^[^\t].+?:.*?##/ \
         {printf "  %-24s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
