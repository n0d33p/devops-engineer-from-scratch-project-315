INVENTORY ?= inventory.ini
IMAGE_TAG ?= latest

bootstrap:
	ansible-galaxy role install -r requirements.yml
	ansible-galaxy collection install -r requirements.yml

deploy:
	ansible-playbook -i $(INVENTORY) playbook.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

update:
	ansible-playbook -i $(INVENTORY) update.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

rollback:
	@test "$(IMAGE_TAG)" != "latest" || (echo "Usage: make rollback IMAGE_TAG=<previous-stable-tag>"; exit 1)
	ansible-playbook -i $(INVENTORY) update.yml --ask-vault-pass -e image_tag=$(IMAGE_TAG)

.PHONY: bootstrap deploy update rollback