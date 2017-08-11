BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)
WORKSPACE := $(shell pwd)

.DEFAULT_GOAL := help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

plan-personal: ## plan with "personal" variables
	terraform plan -var-file=env/personal.tfvars

apply-personal: ## WARNING: apply with "personal" variables
	terraform apply -var-file=env/personal.tfvars

destroy-personal: ## WARNING: Nuke TF with "personal" variables
	terraform destroy -var-file=env/personal.tfvars