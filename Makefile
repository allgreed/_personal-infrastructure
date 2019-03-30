.DEFAULT_GOAL := help

bootstrap: ## run initial configuration (once per new machine)
	ansible-playbook --inventory=inventory --ask-pass provision/bootstrap.yml --user=root
provision: ## apply latest configuration
	ansible-playbook -i inventory provision/playbook.yml

#galaxy_roles: requirements.yml
#	ansible-galaxy install -r requirements.yml --roles-path galaxy_roles

.PHONY: help
help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
