.PHONY: all
all: xwindowsystem bash git vim

.PHONY: xwindowsystem
xwindowsystem:
	@echo -e '\033[0;32m******************************************************\033[0m'
	@echo -e '\033[0;32m************ Installing X11 configuration ************\033[0m'
	@echo -e '\033[0;32m******************************************************\033[0m'
	$(MAKE) -C xwindowsystem all

.PHONY: bash
bash:
	@echo -e '\033[0;32m*******************************************************\033[0m'
	@echo -e '\033[0;32m************ Installing bash configuration ************\033[0m'
	@echo -e '\033[0;32m*******************************************************\033[0m'
	$(MAKE) -C bash all

.PHONY: git
git:
	@echo -e '\033[0;32m******************************************************\033[0m'
	@echo -e '\033[0;32m************ Installing git configuration ************\033[0m'
	@echo -e '\033[0;32m******************************************************\033[0m'
	$(MAKE) -C git all

.PHONY: vim
vim:
	@echo -e '\033[0;32m******************************************************\033[0m'
	@echo -e '\033[0;32m************ Installing vim configuration ************\033[0m'
	@echo -e '\033[0;32m******************************************************\033[0m'
	$(MAKE) -C vim all
