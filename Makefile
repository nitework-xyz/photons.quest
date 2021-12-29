# Right now this is a Docker-level command tool
#
# For instructions on adding new commands:
# https://www.thapaliya.com/en/writings/well-documented-makefiles/

.DEFAULT_GOAL:=help
SHELL:=/bin/bash

##@ Dependencies

.PHONY: init

init:  ## Installing dependencies for development
	$(info Installing dependencies)
	npm install -g http-server


##@ Development

run:  ## Running the local web server for development
	$(info Running the local web server)
	http-server -p 8082 html/

##@ Deployment

deploy: ## Uses zip, scp, and ssh to ship to production
	$(info Deploy to production server)
	zip -R deploy.zip html/*
	echo $(NITEWORK_USER)
	echo $(NITEWORK_IP_ADDRESS)
	scp deploy.zip $(NITEWORK_USER)@$(NITEWORK_IP_ADDRESS):/var/www/photons.quest/deploy.zip
	ssh -t $(NITEWORK_USER)@$(NITEWORK_IP_ADDRESS) 'sudo mv /var/www/photons.quest/html /var/www/photons.quest/html$$(date +"%s") && unzip /var/www/photons.quest/deploy.zip -d /var/www/photons.quest/'
	rm deploy.zip

##@ Helpers

.PHONY: help

help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
