.PHONY: setup-system setup-user backup-restore setup-proxy setup-pbuilder ubuntu-make

setup-system:
	@script/setup-system.sh

setup-user:
	@script/setup-user.sh

backup-restore:
	@script/backup-restore.sh

setup-proxy:
	@script/setup-proxy.sh

setup-pbuilder:
	@script/setup-pbuilder.sh

ubuntu-make:
	@script/ubuntu-make.sh
