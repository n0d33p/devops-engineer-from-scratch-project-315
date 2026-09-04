DOCKER_IMAGE = nxdeep/project-devops-deploy
DOCKER_TAG = latest
INVENTORY ?= inventory.ini
IMAGE_TAG ?= latest

test:
	./gradlew test

start: run

run:
	./gradlew bootRun

update-gradle:
	./gradlew wrapper --gradle-version 9.2.1

update-deps:
	./gradlew refreshVersions

install:
	./gradlew dependencies

build:
	./gradlew build

lint:
	./gradlew spotlessCheck

lint-fix:
	./gradlew spotlessApply

docker-build:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -t $(DOCKER_IMAGE):v1 .

docker-run:
	docker run --rm -p 8080:8080 -p 9090:9090 $(DOCKER_IMAGE):$(DOCKER_TAG)

docker-push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):v1

bootstrap:
	ansible-galaxy collection install -r requirements.yml

deploy:
	ansible-playbook -i $(INVENTORY) playbook.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

update:
	ansible-playbook -i $(INVENTORY) update.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

rollback:
	@test "$(IMAGE_TAG)" != "latest" || (echo "Usage: make rollback IMAGE_TAG=<previous-stable-tag>"; exit 1)
	ansible-playbook -i $(INVENTORY) update.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

.PHONY: test start run update-gradle update-deps install build lint lint-fix docker-build docker-run docker-push bootstrap deploy update rollback