BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/bash

.PHONY: all
all: $(HOME)/.bashrc $(HOME)/.inputrc $(HOME)/.bash_profile $(HOME)/.bash_logout

$(HOME)/.bashrc: $(ROOT)/.bashrc.default
	cp $(ROOT)/.bashrc.default $(HOME)/.bashrc
	@echo "Please run '. $(HOME)/.bashrc' or close and reopen terminal"

$(HOME)/.inputrc: $(ROOT)/.inputrc.default
	cp $(ROOT)/.inputrc.default $(HOME)/.inputrc
	@echo "Please run 'bind -f $(HOME)/.inputrc' or close and reopen terminal"

$(HOME)/.bash_profile: $(ROOT)/.bash_profile
	cp $(ROOT)/.bash_profile $(HOME)/.bash_profile

$(HOME)/.bash_logout: $(ROOT)/.bash_logout
	cp $(ROOT)/.bash_logout $(HOME)/.bash_logout

.PHONY: clean
clean:
	-rm $(ROOT)/.bashrc.default
	-rm $(ROOT)/.inputrc.default
