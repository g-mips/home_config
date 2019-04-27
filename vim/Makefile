BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/vim

.PHONY: all
all: load_vim clean

load_vim: $(ROOT)/.vimrc $(ROOT)/.vimrc.default
	cp $(ROOT)/.vimrc.default $(ROOT)/.vimrc.default.tmp
	sed -i 's|BASE|$(BASE)|' $(ROOT)/.vimrc.default.tmp
	cp $(ROOT)/.vimrc.default.tmp $(HOME)/.vimrc

.PHONY: clean
clean:
	-rm $(ROOT)/.vimrc.default.tmp
