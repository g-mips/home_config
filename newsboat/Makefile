CACHE := $(HOME)/.cache/newsboat
CONFIG := $(HOME)/.config/newsboat

$(shell mkdir -p $(CACHE))
$(shell mkdir -p $(CONFIG))

INIT_CONFIG_FILE = $(CACHE)/init_config

.PHONY: all
all: $(CONFIG)/config

$(INIT_CONFIG_FILE): configure.sh
	./configure.sh

$(CONFIG)/config: config $(INIT_CONFIG_FILE)
	@printf "Copying $< to $@\n"
	@-[ -f $@ ] && cp $@ $(CACHE)/config.old
	cp $< $@
	cat $(INIT_CONFIG_FILE) >> $(CONFIG)/config

.PHONY: restore
restore:
	@-[ -f $(CACHE)/config.old ] && printf "Restoring old $(CONFIG)\n"
	-[ -f $(CACHE)/config.old ] && cp $(CACHE)/config.old $(CONFIG)/config
