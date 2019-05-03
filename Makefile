.DEFAULT_GOAL := help

NOMAD_ADDR := $(strip $(shell cat inventory | tail -n 1))
NOMAD_URL := http://$(NOMAD_ADDR):4646
JOBS := $(shell find jobs -type f -name '*.nomad')

.PHONY: all
all: provision workload

.PHONY: bootstrap provision jobs
bootstrap: ## run initial configuration (once per new machine)
	ansible-playbook --inventory=inventory --ask-pass provision/bootstrap.yml --user=root
provision: provision/galaxy_roles ## apply latest configuration
	ansible-playbook --inventory=inventory --ask-become-pass provision/playbook.yml

.PHONY: $(JOBS) workload
workload: $(JOBS)

$(JOBS):
	nomad job run -address=$(NOMAD_URL) $@

provision/galaxy_roles: provision/requirements.yml
	ansible-galaxy install --force -r provision/requirements.yml --roles-path provision/galaxy_roles

.PHONY: clean
clean:
	rm provision/*.retry

.PHONY: help
help: ## print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
