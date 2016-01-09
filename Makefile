.PHONY: setup-machine
setup-machine:
	@bin/setup-machine.sh

.PHONY: setup-system
setup-system:
	@bin/setup-system.sh

.PHONY: setup-user
setup-user:
	@bin/setup-user.sh

.PHONY: backup-restore
backup-restore:
	@bin/backup-restore.sh

.PHONY: setup-proxy
setup-proxy:
	@bin/setup-proxy.sh

.PHONY: setup-pbuilder
setup-pbuilder:
	@bin/setup-pbuilder.sh

.PHONY: ubuntu-make
ubuntu-make:
	@bin/ubuntu-make.sh
