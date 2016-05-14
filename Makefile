.PHONY: setup
setup:
	@ansible-playbook -vv --ask-become-pass  --skip-tags=restore local.yml

.PHONY: restore
restore:
	@deja-dup --restore

.PHONY: full-setup
full-setup:
	@ansible-playbook -vv --ask-become-pass local.yml
