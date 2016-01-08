.PHONY: setup-machine
setup-machine:
	@script/setup-machine.sh

.PHONY: setup-system
setup-system:
	@script/setup-system.sh

.PHONY: setup-user
setup-user:
	@script/setup-user.sh

.PHONY: backup-restore
backup-restore:
	@script/backup-restore.sh

.PHONY: setup-proxy
setup-proxy:
	@script/setup-proxy.sh

.PHONY: setup-pbuilder
setup-pbuilder:
	@script/setup-pbuilder.sh

.PHONY: ubuntu-make
ubuntu-make:
	@script/ubuntu-make.sh
