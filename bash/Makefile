BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/bash

.PHONY: all
all: $(HOME)/.bashrc $(HOME)/.inputrc clean

$(HOME)/.bashrc: $(ROOT)/.bashrc $(ROOT)/.bashrc.default
	cp $(ROOT)/.bashrc.default $(ROOT)/.bashrc.default.tmp
	sed -i "s|BASE|$(BASE)|" $(ROOT)/.bashrc.default.tmp
	cp $(ROOT)/.bashrc.default.tmp $(HOME)/.bashrc
	echo "Please run '. ~/.bashrc' or close and reopen terminal"

$(HOME)/.inputrc: $(ROOT)/.inputrc $(ROOT)/.inputrc.default
	cp $(ROOT)/.inputrc.default $(ROOT)/.inputrc.default.tmp
	sed -i "s|BASE|$(BASE)|" $(ROOT)/.inputrc.default.tmp
	cp $(ROOT)/.inputrc.default.tmp $(HOME)/.inputrc
	echo "Please close and reopen terminal"

.PHONY: clean
clean:
	-rm $(ROOT)/.bashrc.default.tmp
	-rm $(ROOT)/.inputrc.default.tmp
