.PHONY: setup-system setup-user backup-restore setup-pbuilder ubuntu-make

setup-system:
	@script/setup-system.sh

setup-user:
	@script/setup-user.sh

backup-restore:
	@script/backup-restore.sh

setup-pbuilder:
	@script/setup-pbuilder.sh

ubuntu-make:
	@script/ubuntu-make.sh
