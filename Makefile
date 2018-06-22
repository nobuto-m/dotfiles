.PHONY: setup
setup:
	@ansible-playbook -vv --ask-become-pass --skip-tags=restore local.yml

.PHONY: restore
restore:
	duplicity restore \
	    --verbosity=info \
	    gio+sftp://backup/srv/backup \
	    ~/backup

.PHONY: full-setup
full-setup:
	@rm -f ~/.config/dconf/user.ini
	@ansible-playbook -vv --ask-become-pass local.yml
