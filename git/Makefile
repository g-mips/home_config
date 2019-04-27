BASE := $(shell dirname $(CURDIR))
ROOT = $(BASE)/git

CONFIG_FILE = $(ROOT)/configuration

ifeq ("","$(wildcard $(CONFIG_FILE))")
$(error "Please run ./configure first")
endif

include $(CONFIG_FILE)

.PHONY: all
all: $(HOME)/.gitconfig clean

$(HOME)/.gitconfig: $(ROOT)/.gitconfig $(ROOT)/.gitconfig.default
	cp $(ROOT)/.gitconfig.default $(ROOT)/.gitconfig.default.tmp
	sed -i "s|BASE|$(BASE)|" $(ROOT)/.gitconfig.default.tmp
	sed -i "s|EMAIL|$(EMAIL)|" $(ROOT)/.gitconfig.default.tmp
	sed -i "s|NAME|$(NAME)|" $(ROOT)/.gitconfig.default.tmp
	cp $(ROOT)/.gitconfig.default.tmp $(HOME)/.gitconfig

.PHONY: clean
clean:
	-rm $(ROOT)/.gitconfig.default.tmp

.PHONY: hard_clean
hard_clean: clean
	-rm $(CONFIG_FILE)
