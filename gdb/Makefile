BASE := $(shell dirname $(CURDIR))
ROOT := $(BASE)/gdb

.PHONY: all
all: $(HOME)/.gdbinit

$(include Makefile_config)

$(HOME)/.gdbinit: $(ROOT)/.gdbinit $(ROOT)/.gdbinit.default $(OTHER_FILES)
	cp $(ROOT)/.gdbinit.default $(HOME)/.gdbinit

.PHONY: clean
clean:
	-rm $(ROOT)/.gdbinit.default
	-rm $(ROOT)/Makefile_config
