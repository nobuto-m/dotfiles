.PHONY: setup
setup:
	@ansible-playbook --ask-become-pass  --skip-tags=restore local.yml

.PHONY: restore
restore:
	@deja-dup --restore

.PHONY: full-setup
full-setup:
	@ansible-playbook --ask-become-pass local.yml
