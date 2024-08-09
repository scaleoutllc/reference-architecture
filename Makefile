# Help Helper matches comments at the start of the task block so make help gives users information about each task
.PHONY: help
help: ## Displays information about available make tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

validate: ## Validate entire project.
	bin/infra validate fast-dev

build-network: ## Build multi-cloud dev network.
	bin/infra apply network-dev

destroy-network: ## Destroy multi-cloud dev network.
	bin/infra destroy network-dev