# Help Helper matches comments at the start of the task block so make help gives users information about each task
.PHONY: help
help: ## Displays information about available make tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build-local: ## Build all local clusters.
ifndef AWS_PROFILE
	$(error AWS_PROFILE is undefined)
endif
	terrallel fast-dev-local-clusters -- init
	terrallel fast-dev-local-clusters -- apply -auto-approve
	kubectl apply -k projects/hello-world/environments/fast/dev/local/north-america --context kind-fast-dev-local-us
	kubectl apply -k projects/hello-world/environments/fast/dev/local/australia --context kind-fast-dev-local-au

destroy-local: ## Destroy all local clusters.
	kind delete clusters fast-dev-local-us-mgmt fast-dev-local-us fast-dev-local-au
	find environments/fast/dev/local -name "terraform.tfstate*" -type f -delete