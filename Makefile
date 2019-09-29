# Usage
#
# make 												# builds and run the project
# make build 									# builds the project
# make install 								# builds the project
# make run 										# builds and run the project
# make start									# builds and run the project
# make console 								# opens a ruby console with project loaded
# make shell 									# opens a shell
# make lint 									# runs the linter
# make test 									# runs the test suite
# make spec 									# runs the test suite
# VERSION=1.0.0 make release 	# builds and publish the release

.DEFAULT_GOAL := run

.PHONY: build install run start console shell lint test spec

TARGET_SERVICE = project

build:
	docker-compose build

install:
	docker-compose build

run: build
	docker-compose up

start: build
	docker-compose up

console:
	docker-compose exec ${TARGET_SERVICE} ./bin/console

shell:
	docker-compose exec ${TARGET_SERVICE} /bin/bash

lint:
	docker-compose exec ${TARGET_SERVICE} bundle exec rubocop

test:
	docker-compose exec ${TARGET_SERVICE} bundle exec rspec

spec:
	docker-compose exec ${TARGET_SERVICE} bundle exec rspec

release:
	gem build knowledge.gemspec
	gem push knowledge-${VERSION}.gem
	git tag -a v${VERSION} -m "Version ${VERSION}"
	git push origin --tags
