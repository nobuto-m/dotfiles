.PHONY: setup
setup:
	@ansible-playbook -vv --ask-become-pass \
	    --skip-tags=restore \
	    local.yml

.PHONY: step
step:
	@ansible-playbook -vv --ask-become-pass \
	    --step --start-at-task '$(task)' \
	    local.yml

.PHONY: restore
restore:
	duplicity restore \
	    --verbosity=info \
	    gio+sftp://backup/srv/backup/$(shell hostname) \
	    ~/backup

.PHONY: restore-copy-back
restore-copy-back:
	@ansible-playbook -vv --ask-become-pass \
	    --tags=restore \
	    local.yml

.PHONY: full-setup
full-setup:
	@rm -f ~/.config/dconf/user.ini
	@ansible-playbook -vv --ask-become-pass \
	    local.yml
