.PHONY: setup
setup:
	@ansible-playbook -vv --ask-become-pass --skip-tags=restore local.yml

.PHONY: minimal
minimal:
	@ansible-playbook -vv --ask-become-pass --tags=minimal local.yml

.PHONY: restore
restore:
	duplicity restore \
	    --verbosity=info \
	    gio+sftp://backup/srv/backup \
	    ~/backup

.PHONY: restore-copy-back
restore-copy-back:
	@ansible-playbook -vv --ask-become-pass --tags=restore local.yml

.PHONY: full-setup
full-setup:
	@ansible-playbook -vv --ask-become-pass local.yml
