# Help Helper matches comments at the start of the task block so make help gives users information about each task
.PHONY: help
help: ## Displays information about available make tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

validate-network: ## Validate fast-dev network.
	bin/infra validate fast-dev network

build-network: ## Build fast-dev network.
	bin/infra apply fast-dev network

destroy-network: ## Destroy fast-dev network.
	bin/infra destroy fast-dev network

validate-envs: ## Validate fast-dev environments.
	parallel --ungroup "bin/infra validate fast-dev" ::: aws-us aws-au gcp-us gcp-au

build-envs: ## Build fast-dev environments.
	parallel --ungroup "bin/infra apply fast-dev" ::: aws-us aws-au gcp-us gcp-au

destroy-envs: ## Tear down fast-dev environments
	parallel --ungroup "bin/infra destroy fast-dev" ::: aws-us aws-au gcp-us gcp-au
