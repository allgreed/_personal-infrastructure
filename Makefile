.DEFAULT_GOAL := help

.PHONY: bootstrap provision
bootstrap: ## run initial configuration (once per new machine)
	ansible-playbook --inventory=inventory --ask-pass provision/bootstrap.yml --user=root
provision: provision/galaxy_roles ## apply latest configuration
	ansible-playbook --inventory=inventory --ask-become-pass provision/playbook.yml

provision/galaxy_roles: provision/requirements.yml
	ansible-galaxy install -r provision/requirements.yml --roles-path provision/galaxy_roles

.PHONY: clean
clean:
	rm provision/*.retry

.PHONY: help
help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
